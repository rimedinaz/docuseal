ARG RUBY_VERSION=3.2.2
FROM ruby:${RUBY_VERSION}-alpine AS prepare

WORKDIR /artifacts

# Install fontforge
RUN apk --no-cache add fontforge

# Copy artifacts from the build context
COPY standalone/artifacts/fonts /fonts
COPY standalone/artifacts/model.onnx /model.onnx
COPY standalone/artifacts/pdfium-linux.tgz /pdfium-linux.tgz

# Process fonts
RUN mkdir -p /processed_fonts && \
    cp /fonts/* /processed_fonts/ && \
    cd /processed_fonts && \
    fontforge -lang=py -c 'font1 = fontforge.open("FreeSans.ttf"); font2 = fontforge.open("NotoSansSymbols2-Regular.ttf"); font1.mergeFonts(font2); font1.generate("FreeSans.ttf")'

# Process PDFium
RUN mkdir -p /pdfium-linux && \
    tar -xzf /pdfium-linux.tgz -C /pdfium-linux

# Webpack stage
FROM ruby:${RUBY_VERSION}-alpine AS webpack
ENV RAILS_ENV=production
ENV NODE_ENV=production
WORKDIR /app
RUN apk add --no-cache nodejs yarn git build-base && \
    gem install shakapacker

COPY package.json yarn.lock ./

RUN yarn install --network-timeout 1000000

COPY bin/shakapacker bin/shakapacker
COPY config/webpack config/webpack
COPY config/shakapacker.yml config/shakapacker.yml
COPY postcss.config.js postcss.config.js
COPY tailwind.config.js tailwind.config.js
COPY tailwind.form.config.js tailwind.form.config.js
COPY tailwind.application.config.js tailwind.application.config.js
COPY app/javascript app/javascript
COPY app/views app/views

RUN echo "gem 'shakapacker'" > Gemfile && ./bin/shakapacker

# App stage
FROM ruby:${RUBY_VERSION}-alpine AS app
ENV RAILS_ENV=production
ENV BUNDLE_WITHOUT="development:test"
ENV LD_PRELOAD=/lib/libgcompat.so.0
ENV OPENSSL_CONF=/etc/openssl_legacy.cnf

WORKDIR /app

RUN apk add --no-cache sqlite-dev libpq-dev vips-dev yaml-dev redis libheif vips-heif gcompat ttf-freefont onnxruntime && \
    mkdir /fonts && \
    rm /usr/share/fonts/freefont/FreeSans.otf

RUN addgroup -g 2000 docuseal && adduser -u 2000 -G docuseal -s /bin/sh -D -h /home/docuseal docuseal

# OpenSSL legacy configuration
RUN echo $'.include = /etc/ssl/openssl.cnf\n\
\n\
[provider_sect]\n\
default = default_sect\n\
legacy = legacy_sect\n\
\n\
[default_sect]\n\
activate = 1\n\
\n\
[legacy_sect]\n\
activate = 1' >> /etc/openssl_legacy.cnf

COPY --chown=docuseal:docuseal Gemfile Gemfile.lock ./

RUN apk add --no-cache build-base git && \
    bundle install && \
    apk del --no-cache build-base git && \
    rm -rf ~/.bundle /usr/local/bundle/cache && \
    ruby -e "puts Dir['/usr/local/bundle/**/{spec,rdoc,resources/shared,resources/collation,resources/locales}']" | xargs rm -rf && \
    ln -sf /usr/lib/libonnxruntime.so.1 $(ruby -e "print Dir[Gem::Specification.find_by_name('onnxruntime').gem_dir + '/vendor/*.so'].first")

COPY --chown=docuseal:docuseal bin bin
COPY --chown=docuseal:docuseal app app
COPY --chown=docuseal:docuseal config config
COPY --chown=docuseal:docuseal db/migrate db/migrate
COPY --chown=docuseal:docuseal log log
COPY --chown=docuseal:docuseal lib lib
COPY --chown=docuseal:docuseal public public
COPY --chown=docuseal:docuseal tmp tmp
COPY --chown=docuseal:docuseal LICENSE README.md Rakefile config.ru .version ./
COPY --chown=docuseal:docuseal .version ./public/version

# Copy prepared artifacts
COPY --chown=docuseal:docuseal --from=prepare /processed_fonts/GoNotoKurrent-Regular.ttf /processed_fonts/GoNotoKurrent-Bold.ttf /processed_fonts/DancingScript-Regular.otf /processed_fonts/OFL.txt /fonts/
COPY --from=prepare /processed_fonts/FreeSans.ttf /usr/share/fonts/freefont/
COPY --from=prepare /pdfium-linux/lib/libpdfium.so /usr/lib/libpdfium.so
COPY --from=prepare /pdfium-linux/licenses/pdfium.txt /usr/lib/libpdfium-LICENSE.txt
COPY --chown=docuseal:docuseal --from=prepare /model.onnx /app/tmp/model.onnx
COPY --chown=docuseal:docuseal --from=webpack /app/public/packs ./public/packs

RUN ln -s /fonts /app/public/fonts && \
    bundle exec bootsnap precompile -j 1 --gemfile app/ lib/ && \
    chown -R docuseal:docuseal /app/tmp/cache

WORKDIR /data/docuseal
ENV HOME=/home/docuseal
ENV WORKDIR=/data/docuseal

EXPOSE 3000
CMD ["/app/bin/bundle", "exec", "puma", "-C", "/app/config/puma.rb", "--dir", "/app"]

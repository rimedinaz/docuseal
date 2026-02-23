### Start the Server

Source: https://github.com/docusealco/docuseal/wiki/Ubuntu-Setup

Starts the Rails server in production environment.

```shell
RAILS_ENV=production ./bin/rails server
```

--------------------------------

### Install Ruby 3.2.2

Source: https://github.com/docusealco/docuseal/wiki/Ubuntu-Setup

Installs Ruby version 3.2.2 using rbenv and sets it as the global version. Requires Ruby 3.2.2 to be installed.

```shell
rbenv install 3.2.2
rbenv global 3.2.2
```

--------------------------------

### Install System Dependencies

Source: https://github.com/docusealco/docuseal/wiki/Ubuntu-Setup

Installs necessary system libraries for Docuseal on Debian/Ubuntu-based systems using apt-get. Includes SQLite, PostgreSQL, MariaDB, and Vips development files.

```shell
sudo apt-get install git sqlite3 libsqlite3-dev libpq-dev libmariadb-dev libvips-dev
```

--------------------------------

### Install Ruby Gems

Source: https://github.com/docusealco/docuseal/wiki/Ubuntu-Setup

Installs all required Ruby gems specified in the project's Gemfile using Bundler.

```shell
bundle install
```

--------------------------------

### Precompile Assets and Install Dependencies

Source: https://github.com/docusealco/docuseal/wiki/Ubuntu-Setup

Installs Node.js dependencies using Yarn and precompiles frontend assets for production using Shakapacker. Requires NodeJS 16.

```shell
npm install -g yarn
yarn install
RAILS_ENV=production ./bin/shakapacker
```

--------------------------------

### Clone Docuseal Repository

Source: https://github.com/docusealco/docuseal/wiki/Ubuntu-Setup

Clones the Docuseal project from GitHub and navigates into the project directory.

```shell
git clone https://github.com/docusealco/docuseal.git
cd docuseal
```

--------------------------------

### Go Client for Listing Submitters

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/go.md

Example Go code demonstrating how to make a GET request to the Docuseal API to list submitters. It includes setting the API key and handling the response.

```go
package main

import (
	"fmt"
	"net/http"
	"io"
)

func main() {

	url := "https://api.docuseal.com/submitters"

	req, _ := http.NewRequest("GET", url, nil)

	req.Header.Add("X-Auth-Token", "API_KEY")

	res, _ := http.DefaultClient.Do(req)

	defer res.Body.Close()
	body, _ := io.ReadAll(res.Body)

	fmt.Println(res)
	fmt.Println(string(body))

}
```

--------------------------------

### List Submitters Request Example

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/java.md

Example Java code using Unirest to make an HTTP GET request to the Docuseal API to retrieve a list of submitters. It includes setting the authentication token.

```java
HttpResponse<String> response = Unirest.get("https://api.docuseal.com/submitters")
  .header("X-Auth-Token", "API_KEY")
  .asString();
```

--------------------------------

### Merge Templates Request Example

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/java.md

Example of how to use the Unirest library in Java to send a POST request to the template merge API endpoint.

```java
HttpResponse<String> response = Unirest.post("https://api.docuseal.com/templates/merge")
  .header("X-Auth-Token", "API_KEY")
  .header("content-type", "application/json")
  .body("{\"template_ids\":[321,432],\"name\":\"Merged Template\"}")
  .asString();
```

--------------------------------

### Get Template API: Go Example & OpenAPI Spec

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/go.md

Demonstrates how to retrieve detailed information for a specific document template using its ID via the DocuSeal API with a Go client. Includes the OpenAPI specification for the GET endpoint.

```Go
package main

import (
	"fmt"
	"net/http"
	"io"
)

func main() {

	url := "https://api.docuseal.com/templates/1000001"

	req, _ := http.NewRequest("GET", url, nil)

	req.Header.Add("X-Auth-Token", "API_KEY")

	res, _ := http.DefaultClient.Do(req)

	defer res.Body.Close()
	body, _ := io.ReadAll(res.Body)

	fmt.Println(res)
	fmt.Println(string(body))

}
```

```APIDOC
{
  "security": [
    {
      "AuthToken": []
    }
  ],
  "tags": [
    "Templates"
  ],
  "summary": "Get a template",
  "operationId": "getTemplate",
  "parameters": [
    {
      "name": "id",
      "in": "path",
      "required": true,
      "schema": {
        "type": "integer"
      },
      "description": "The unique identifier of the document template.",
      "example": 1000001
    }
  ]
}
```

--------------------------------

### Run DocuSeal Docker Container

Source: https://github.com/docusealco/docuseal/blob/master/README.md

This command starts a DocuSeal Docker container, mapping port 3000 and mounting a local volume for data persistence. By default, it uses an SQLite database.

```sh
docker run --name docuseal -p 3000:3000 -v.:/data docuseal/docuseal
```

--------------------------------

### Access Render Dashboard

Source: https://github.com/docusealco/docuseal/wiki/How-to-Update-DocuSeal-App-Installed-Using-the-"Deploy-to-Render"-Button

Provides the URL to access the Render dashboard, which is the first step in deploying the DocuSeal instance. This link is used to navigate to the deployment platform.

```text
https://dashboard.render.com/
```

--------------------------------

### Create Submission Request (Go)

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/go.md

Example Go code demonstrating how to create a signature request submission via the DocuSeal API. It includes setting up the HTTP request, headers, and the JSON payload.

```go
package main

import (
	"fmt"
	"strings"
	"net/http"
	"io"
)

func main() {

	url := "https://api.docuseal.com/submissions"

	payload := strings.NewReader("{\"template_id\":1000001,\"send_email\":true,\"submitters\":[{\"role\":\"First Party\",\"email\":\"john.doe@example.com\"}]}")

	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("X-Auth-Token", "API_KEY")
	req.Header.Add("content-type", "application/json")

	res, _ := http.DefaultClient.Do(req)

	defer res.Body.Close()
	body, _ := io.ReadAll(res.Body)

	fmt.Println(res)
	fmt.Println(string(body))

}
```

--------------------------------

### List Templates API: Go Example & OpenAPI Spec

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/go.md

Demonstrates how to list all available document templates using the DocuSeal API with a Go client. Includes the OpenAPI specification detailing parameters for filtering and pagination.

```Go
package main

import (
	"fmt"
	"net/http"
	"io"
)

func main() {

	url := "https://api.docuseal.com/templates"

	req, _ := http.NewRequest("GET", url, nil)

	req.Header.Add("X-Auth-Token", "API_KEY")

	res, _ := http.DefaultClient.Do(req)

	defer res.Body.Close()
	body, _ := io.ReadAll(res.Body)

	fmt.Println(res)
	fmt.Println(string(body))

}
```

```APIDOC
{
  "security": [
    {
      "AuthToken": []
    }
  ],
  "tags": [
    "Templates"
  ],
  "summary": "List all templates",
  "operationId": "getTemplates",
  "parameters": [
    {
      "name": "q",
      "in": "query",
      "required": false,
      "schema": {
        "type": "string"
      },
      "description": "Filter templates based on the name partial match."
    },
    {
      "name": "slug",
      "in": "query",
      "required": false,
      "schema": {
        "type": "string"
      },
      "description": "Filter templates by unique slug.",
      "example": "opaKWh8WWTAcVG"
    },
    {
      "name": "external_id",
      "in": "query",
      "required": false,
      "schema": {
        "type": "string"
      },
      "description": "The unique applications-specific identifier provided for the template via API or Embedded template form builder. It allows you to receive only templates with your specified external id."
    },
    {
      "name": "folder",
      "in": "query",
      "required": false,
      "schema": {
        "type": "string"
      },
      "description": "Filter templates by folder name."
    },
    {
      "name": "archived",
      "in": "query",
      "required": false,
      "schema": {
        "type": "boolean"
      },
      "description": "Get only archived templates instead of active ones."
    },
    {
      "name": "limit",
      "in": "query",
      "required": false,
      "schema": {
        "type": "integer"
      },
      "description": "The number of templates to return. Default value is 10. Maximum value is 100."
    },
    {
      "name": "after",
      "in": "query",
      "required": false,
      "schema": {
        "type": "integer"
      },
      "description": "The unique identifier of the template to start the list from. It allows you to receive only templates with id greater than the specified value. Pass ID value from the `pagination.next` response to load the next batch of templates."
    },
    {
      "name": "before",
      "in": "query",
      "required": false,
      "schema": {
        "type": "integer"
      },
      "description": "The unique identifier of the template to end the list with. It allows you to receive only templates with id less than the specified value."
    }
  ]
}
```

--------------------------------

### List Submissions API (C#)

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/csharp.md

This C# code snippet illustrates how to fetch a list of submissions from the DocuSeal API. It shows the setup for a GET request, including the base URL and the necessary authentication header.

```csharp
var client = new RestClient("https://api.docuseal.com/submissions");
var request = new RestRequest("", Method.Get);
request.AddHeader("X-Auth-Token", "API_KEY");
var response = client.Execute(request);
```

--------------------------------

### Merge Templates Python Example

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/python.md

Demonstrates how to merge multiple templates using the docuseal Python SDK. Requires API key and URL configuration. Takes a list of template IDs and an optional name for the new template.

```python
from docuseal import docuseal

docuseal.key = "API_KEY"
docuseal.url = "https://api.docuseal.com"

docuseal.merge_templates({
  "template_ids": [
    321,
    432
  ],
  "name": "Merged Template"
})
```

--------------------------------

### List All Submissions

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/javascript.md

Provides a JavaScript example for fetching a list of submissions using the Docuseal API. It shows how to configure the API client and make the request, including optional filtering parameters.

```javascript
const docuseal = require("@docuseal/api");

docuseal.configure({ key: "API_KEY", url: "https://api.docuseal.com" });

const { data, pagination } = await docuseal.listSubmissions({ limit: 10 });
```

--------------------------------

### Create Template from PDF (C# Client)

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/csharp.md

Example C# code demonstrating how to use the RestClient to call the DocuSeal API to create a template from a PDF file. It includes setting the API key, content type, and request body with template details.

```csharp
var client = new RestClient("https://api.docuseal.com/templates/pdf");
var request = new RestRequest("", Method.Post);
request.AddHeader("X-Auth-Token", "API_KEY");
request.AddHeader("content-type", "application/json");
request.AddParameter("application/json", "{\"name\":\"Test PDF\",\"documents\":[{\"name\":\"string\",\"file\":\"base64\",\"fields\":[{\"name\":\"string\",\"areas\":[{\"x\":0,\"y\":0,\"w\":0,\"h\":0,\"page\":1}]}]}]}", ParameterType.RequestBody);
var response = client.Execute(request);
```

--------------------------------

### Create DOCX Template using Java

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/java.md

Example of how to use the Unirest library in Java to send a POST request to the DocuSeal API to create a template from a DOCX file. It includes setting the authentication token and the request body with document details.

```java
HttpResponse<String> response = Unirest.post("https://api.docuseal.com/templates/docx")
  .header("X-Auth-Token", "API_KEY")
  .header("content-type", "application/json")
  .body("{\"name\":\"Test DOCX\",\"documents\":[{\"name\":\"string\",\"file\":\"base64\"}]}")
  .asString();
```

--------------------------------

### Create DOCX Template (C#)

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/csharp.md

C# example using RestClient to send a POST request to the DocuSeal API to create a document template from a DOCX file. Requires an API key for authentication and sends document details in JSON format.

```csharp
var client = new RestClient("https://api.docuseal.com/templates/docx");
var request = new RestRequest("", Method.Post);
request.AddHeader("X-Auth-Token", "API_KEY");
request.AddHeader("content-type", "application/json");
request.AddParameter("application/json", "{\"name\":\"Test DOCX\",\"documents\":[{\"name\":\"string\",\"file\":\"base64\"}]}", ParameterType.RequestBody);
var response = client.Execute(request);
```

--------------------------------

### Create Submission API Endpoint

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/csharp.md

API documentation detailing the request body schema for creating a submission. It outlines required and optional parameters, their types, descriptions, and examples for configuring signature requests.

```APIDOC
OpenAPI:
  paths:
    /submissions:
      post:
        summary: Create a submission
        operationId: createSubmission
        tags:
          - Submissions
        security:
          - AuthToken: []
        requestBody:
          required: true
          content:
            application/json:
              schema:
                type: object
                required:
                  - template_id
                  - submitters
                properties:
                  template_id:
                    type: integer
                    description: The unique identifier of the template. Document template forms can be created via the Web UI, <a href="https://www.docuseal.com/guides/use-embedded-text-field-tags-in-the-pdf-to-create-a-fillable-form" class="link">PDF and DOCX API</a>, or <a href="https://www.docuseal.com/guides/create-pdf-document-fillable-form-with-html-api" class="link">HTML API</a>.
                    example: 1000001
                  send_email:
                    type: boolean
                    description: Set `false` to disable signature request emails sending.
                    default: true
                  send_sms:
                    type: boolean
                    description: Set `true` to send signature request via phone number and SMS.
                    default: false
                  order:
                    type: string
                    description: Pass 'random' to send signature request emails to all parties right away. The order is 'preserved' by default so the second party will receive a signature request email only after the document is signed by the first party.
                    default: "preserved"
                    enum:
                      - preserved
                      - random
                  completed_redirect_url:
                    type: string
                    description: Specify URL to redirect to after the submission completion.
                  bcc_completed:
                    type: string
                    description: Specify BCC address to send signed documents to after the completion.
                  reply_to:
                    type: string
                    description: Specify Reply-To address to use in the notification emails.
                  expire_at:
                    type: string
                    description: Specify the expiration date and time after which the submission becomes unavailable for signature.
                    example: "2024-09-01 12:00:00 UTC"
                  message:
                    type: object
                    properties:
                      subject:
                        type: string
                        description: Custom signature request email subject.
                      body:
                        type: string
                        description: Custom signature request email body. Can include the following variables: {{template.name}}, {{submitter.link}}, {{account.name}}.
                  submitters:
                    type: array
                    description: The list of submitters for the submission.
                    items:
                      type: object
                      required:
                        - email
                      properties:
                        name:
                          type: string
                          description: The name of the submitter.
                        role:
                          type: string
                          description: The role name or title of the submitter.
                          example: "First Party"
                        email:
                          type: string
                          description: The email address of the submitter.
                          format: email
                          example: "john.doe@example.com"
```

--------------------------------

### List Submissions API and PHP SDK

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/php.md

This section provides details on retrieving a list of submissions, including filtering options. It includes both the API endpoint definition and a PHP SDK example for fetching submissions.

```PHP
$docuseal = new \Docuseal\Api('API_KEY', 'https://api.docuseal.com');

$docuseal->listSubmissions(['limit' => 10]);
```

```APIDOC
{
  "security": [
    {
      "AuthToken": []
    }
  ],
  "tags": [
    "Submissions"
  ],
  "summary": "List all submissions",
  "operationId": "getSubmissions",
  "parameters": [
    {
      "name": "template_id",
      "in": "query",
      "required": false,
      "schema": {
        "type": "integer"
      },
      "description": "The template ID allows you to receive only the submissions created from that specific template."
    },
    {
      "name": "status",
      "in": "query",
      "required": false,
      "schema": {
        "type": "string",
        "enum": [
          "pending",
          "completed",
          "declined",
          "expired"
        ]
      },
      "description": "Filter submissions by status."
    },
    {
      "name": "q",
      "in": "query",
      "required": false,
      "schema": {
        "type": "string"
      },
      "description": "Filter submissions based on submitters name, email or phone partial match."
    },
    {
      "name": "slug",
      "in": "query",
      "required": false,
      "schema": {
        "type": "string"
      },
      "description": "Filter submissions by unique slug.",
      "example": "NtLDQM7eJX2ZMd"
    },
    {
      "name": "template_folder",
      "in": "query",
      "required": false,
      "schema": {
        "type": "string"
      },
      "description": "Filter submissions by template folder name."
    },
    {
      "name": "archived",
      "in": "query",
      "required": false,
      "schema": {
        "type": "boolean"
      },
      "description": "Returns only archived submissions when `true` and only active submissions when `false`."
    },
    {
      "name": "limit",
      "in": "query",
      "required": false,
      "schema": {
        "type": "integer"
      },
      "description": "The number of submissions to return. Default value is 10. Maximum value is 100."
    },
    {
      "name": "after",
      "in": "query",
      "required": false,
      "schema": {
        "type": "integer"
      },
      "description": "The unique identifier of the submission to start the list from. It allows you to receive only submissions with an ID greater than the specified value. Pass ID value from the `pagination.next` response to load the next batch of submissions."
    },
    {
      "name": "before",
      "in": "query",
      "required": false,
      "schema": {
        "type": "integer"
      },
      "description": "The unique identifier of the submission that marks the end of the list. It allows you to receive only submissions with an ID less than the specified value."
    }
  ]
}
```

--------------------------------

### Create Template from PDF Request (Java)

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/java.md

Example of making an API request using Java's Unirest library to create a template from a PDF. It demonstrates setting the authentication token, content type, and constructing the JSON request body.

```java
HttpResponse<String> response = Unirest.post("https://api.docuseal.com/templates/pdf")
  .header("X-Auth-Token", "API_KEY")
  .header("content-type", "application/json")
  .body("{\"name\":\"Test PDF\",\"documents\":[{\"name\":\"string\",\"file\":\"base64\",\"fields\":[{\"name\":\"string\",\"areas\":[{\"x\":0,\"y\":0,\"w\":0,\"h\":0,\"page\":1}]}]}]}")
  .asString();
```

--------------------------------

### Create Submission from HTML (C#)

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/csharp.md

Example of creating a submission document from HTML content using the DocuSeal API with C# and RestSharp. It demonstrates setting authentication, headers, and the JSON request body.

```csharp
var client = new RestClient("https://api.docuseal.com/submissions/html");
var request = new RestRequest("", Method.Post);
request.AddHeader("X-Auth-Token", "API_KEY");
request.AddHeader("content-type", "application/json");
request.AddParameter("application/json", "{\"name\":\"Test Submission Document\",\"documents\":[{\"name\":\"Test Document\",\"html\":\"<p>Lorem Ipsum is simply dummy text of the\\n<text-field\\n  name=\"Industry\\"\\n  role=\"First Party\\"\\n  required=\"false\\"\\n  style=\"width: 80px; height: 16px; display: inline-block; margin-bottom: -4px\">\n</text-field>\\nand typesetting industry</p>\\n"}],\"submitters\":[{\"role\":\"First Party\",\"email\":\"john.doe@example.com\"}]}", ParameterType.RequestBody);
var response = client.Execute(request);
```

--------------------------------

### PHP SDK: Create Template from PDF

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/php.md

Use the DocuSeal PHP SDK to create a template from a PDF. This example shows how to instantiate the API client and call the `createTemplateFromPdf` method, specifying template details and document fields.

```PHP
$docuseal = new \Docuseal\Api('API_KEY', 'https://api.docuseal.com');

$docuseal->createTemplateFromPdf([
  'name' => 'Test PDF',
  'documents' => [
    [
      'name' => 'string',
      'file' => 'base64',
      'fields' => [
        [
          'name' => 'string',
          'areas' => [
            [
              'x' => 0,
              'y' => 0,
              'w' => 0,
              'h' => 0,
              'page' => 1
            ]
          ]
        ]
      ]
    ]
  ]
]);
```

--------------------------------

### List Submitters with Node.js

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/nodejs.md

Example code demonstrating how to fetch a list of submitters from the Docuseal API using Node.js and the `node-fetch` library. It includes setting the API key for authentication and parsing the JSON response.

```nodejs
const fetch = require("node-fetch");

const resp = await fetch("https://api.docuseal.com/submitters", {
  method: "GET",
  headers: {
    "X-Auth-Token": "API_KEY"
  }
});

const { data, pagination } = await resp.json();
```

--------------------------------

### Create Template from PDF (cURL)

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/shell.md

Example cURL command to create a document template from a PDF file. It specifies the API endpoint, authentication token, and the request body containing template details and the PDF file.

```shell
curl --request POST \
  --url https://api.docuseal.com/templates/pdf \
  --header 'X-Auth-Token: API_KEY' \
  --header 'content-type: application/json' \
  --data '{"name":"Test PDF","documents":[{"name":"string","file":"base64","fields":[{"name":"string","areas":[{"x":0,"y":0,"w":0,"h":0,"page":1}]}]}]}'
```

--------------------------------

### Create Template from DOCX (TypeScript)

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/typescript.md

Example of using the Docuseal API client to create a new template from a Word DOCX file. It shows configuration and the call to the `createTemplateFromDocx` method, requiring a template name and document details including the base64-encoded file content.

```TypeScript
import docuseal from "@docuseal/api";

docuseal.configure({ key: "API_KEY", url: "https://api.docuseal.com" });

const template = await docuseal.createTemplateFromDocx({
  name: "Test DOCX",
  documents: [
    {
      name: "string",
      file: "base64"
    }
  ]
});
```

--------------------------------

### Clone Template (Python)

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/python.md

Provides an example of cloning an existing template using the Docuseal Python client. This operation requires the ID of the template to be cloned and allows specifying a new name, folder, or external ID for the cloned template.

```python
from docuseal import docuseal

docuseal.key = "API_KEY"
docuseal.url = "https://api.docuseal.com"

docuseal.clone_template(1000001, {
  "name": "Cloned Template"
})
```

--------------------------------

### Get Submitter Details

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/php.md

This section covers retrieving submitter information using the Docuseal API. It includes a PHP client example and the OpenAPI specification for the 'getSubmitter' endpoint.

```PHP
$docuseal = new \Docuseal\Api('API_KEY', 'https://api.docuseal.com');

$docuseal->getSubmitter(500001);
```

```APIDOC
{
  "security": [
    {
      "AuthToken": []
    }
  ],
  "tags": [
    "Submitters"
  ],
  "summary": "Get a submitter",
  "operationId": "getSubmitter",
  "parameters": [
    {
      "name": "id",
      "in": "path",
      "required": true,
      "schema": {
        "type": "integer"
      },
      "description": "The unique identifier of the submitter.",
      "example": 500001
    }
  ]
}
```

--------------------------------

### Archive Template API: Go Example & OpenAPI Spec

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/go.md

Demonstrates how to archive a document template using its ID via the DocuSeal API with a Go client. Includes the OpenAPI specification for the DELETE endpoint.

```Go
package main

import (
	"fmt"
	"net/http"
	"io"
)

func main() {

	url := "https://api.docuseal.com/templates/1000001"

	req, _ := http.NewRequest("DELETE", url, nil)

	req.Header.Add("X-Auth-Token", "API_KEY")

	res, _ := http.DefaultClient.Do(req)

	defer res.Body.Close()
	body, _ := io.ReadAll(res.Body)

	fmt.Println(res)
	fmt.Println(string(body))

}
```

```APIDOC
{
  "security": [
    {
      "AuthToken": []
    }
  ],
  "tags": [
    "Templates"
  ],
  "summary": "Archive a template",
  "operationId": "archiveTemplate",
  "parameters": [
    {
      "name": "id",
      "in": "path",
      "required": true,
      "schema": {
        "type": "integer"
      },
      "description": "The unique identifier of the document template.",
      "example": 1000001
    }
  ]
}
```

--------------------------------

### Get Specific Template API

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/nodejs.md

Shows how to retrieve detailed information for a specific document template by its unique identifier. The example uses Node.js with the fetch API, including authentication.

```nodejs
const fetch = require("node-fetch");

const resp = await fetch("https://api.docuseal.com/templates/1000001", {
  method: "GET",
  headers: {
    "X-Auth-Token": "API_KEY"
  }
});

const template = await resp.json();
```

--------------------------------

### Create Template from PDF (Node.js)

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/nodejs.md

Example Node.js code using `node-fetch` to send a POST request to the DocuSeal API to create a template from a PDF file. Demonstrates setting headers and request body with document details and fields.

```nodejs
const fetch = require("node-fetch");

const resp = await fetch("https://api.docuseal.com/templates/pdf", {
  method: "POST",
  headers: {
    "X-Auth-Token": "API_KEY"
  },
  body: JSON.stringify({
    name: "Test PDF",
    documents: [
      {
        name: "string",
        file: "base64",
        fields: [
          {
            name: "string",
            areas: [
              {
                x: 0,
                y: 0,
                w: 0,
                h: 0,
                page: 1
              }
            ]
          }
        ]
      }
    ]
  })
});

const template = await resp.json();
```

--------------------------------

### Deploy DocuSeal with Docker Compose

Source: https://github.com/docusealco/docuseal/blob/master/README.md

This command downloads the docker-compose.yml file to your server. You can then use Docker Compose to manage the DocuSeal application, including custom domains and SSL certificates via Caddy.

```sh
curl https://raw.githubusercontent.com/docusealco/docuseal/master/docker-compose.yml > docker-compose.yml
sudo HOST=your-domain-name.com docker compose up
```

--------------------------------

### Get Submission API

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/java.md

Retrieves detailed information about a specific submission using its unique identifier. This endpoint requires authentication and returns submission data. The example demonstrates usage with the Unirest Java library.

```Java
HttpResponse<String> response = Unirest.get("https://api.docuseal.com/submissions/1001")
  .header("X-Auth-Token", "API_KEY")
  .asString();
```

```APIDOC
{
  "security": [
    {
      "AuthToken": []
    }
  ],
  "tags": [
    "Submissions"
  ],
  "summary": "Get a submission",
  "operationId": "getSubmission",
  "parameters": [
    {
      "name": "id",
      "in": "path",
      "required": true,
      "schema": {
        "type": "integer"
      },
      "description": "The unique identifier of the submission.",
      "example": 1001
    }
  ]
}
```

--------------------------------

### Create Submission from HTML (Go)

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/go.md

Demonstrates creating a submission request using the DocuSeal API with provided HTML content. It shows how to construct the POST request, set headers, and handle the response.

```go
package main

import (
	"fmt"
	"strings"
	"net/http"
	"io"
)

func main() {

	url := "https://api.docuseal.com/submissions/html"

	payload := strings.NewReader("{\"name\":\"Test Submission Document\",\"documents\":[{\"name\":\"Test Document\",\"html\":\"<p>Lorem Ipsum is simply dummy text of the\\n<text-field\\n  name=\"Industry\"\n  role=\"First Party\"\n  required=\"false\"\n  style=\"width: 80px; height: 16px; display: inline-block; margin-bottom: -4px\">\n</text-field>\\nand typesetting industry</p>\\n\"}],\"submitters\":[{\"role\":\"First Party\",\"email\":\"john.doe@example.com\"}]}")

	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("X-Auth-Token", "API_KEY")
	req.Header.Add("content-type", "application/json")

	res, _ := http.DefaultClient.Do(req)

	defer res.Body.Close()
	body, _ := io.ReadAll(res.Body)

	fmt.Println(res)
	fmt.Println(string(body))

}
```

--------------------------------

### List Submitters API Request (C#)

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/csharp.md

Example C# code using RestSharp to make a GET request to the Docuseal API to list submitters. It includes setting the API endpoint and authentication token.

```csharp
var client = new RestClient("https://api.docuseal.com/submitters");
var request = new RestRequest("", Method.Get);
request.AddHeader("X-Auth-Token", "API_KEY");
var response = client.Execute(request);
```

--------------------------------

### Create PDF Template with Go

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/go.md

Demonstrates how to make a POST request to the DocuSeal API to create a new template from a PDF file. It includes setting up the request payload with document details and fields, and authenticating with an API key.

```go
package main

import (
	"fmt"
	"strings"
	"net/http"
	"io"
)

func main() {

	url := "https://api.docuseal.com/templates/pdf"

	payload := strings.NewReader("{\"name\":\"Test PDF\",\"documents\":[{\"name\":\"string\",\"file\":\"base64\",\"fields\":[{\"name\":\"string\",\"areas\":[{\"x\":0,\"y\":0,\"w\":0,\"h\":0,\"page\":1}]}]}]}")

	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("X-Auth-Token", "API_KEY")
	req.Header.Add("content-type", "application/json")

	res, _ := http.DefaultClient.Do(req)

	defer res.Body.Close()
	body, _ := io.ReadAll(res.Body)

	fmt.Println(res)
	fmt.Println(string(body))

}
```

--------------------------------

### Get Submission Documents API

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/java.md

Retrieves documents associated with a submission. It returns partially filled documents if the submission is ongoing, or the final signed documents if completed. The example demonstrates fetching documents using the Unirest Java library.

```Java
HttpResponse<String> response = Unirest.get("https://api.docuseal.com/submissions/1001/documents")
  .header("X-Auth-Token", "API_KEY")
  .asString();
```

```APIDOC
{
  "security": [
    {
      "AuthToken": []
    }
  ],
  "tags": [
    "Submissions"
  ],
  "summary": "Get submission documents",
  "operationId": "getSubmissionDocuments",
  "parameters": [
    {
      "name": "id",
      "in": "path",
      "required": true,
      "schema": {
        "type": "integer"
      },
      "description": "The unique identifier of the submission.",
      "example": 1001
    }
  ]
}
```

--------------------------------

### Get Submitter Information (Ruby & API)

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/ruby.md

Retrieves detailed information about a submitter, including their associated documents and field values. The Ruby example shows how to fetch this data using the Docuseal gem. The API specification outlines the endpoint and parameter requirements.

```ruby
require "docuseal"

Docuseal.key = ENV["DOCUSEAL_API_KEY"]
Docuseal.url = "https://api.docuseal.com"

Docuseal.get_submitter(500001)
```

```APIDOC
{
  "security": [
    {
      "AuthToken": []
    }
  ],
  "tags": [
    "Submitters"
  ],
  "summary": "Get a submitter",
  "operationId": "getSubmitter",
  "parameters": [
    {
      "name": "id",
      "in": "path",
      "required": true,
      "schema": {
        "type": "integer"
      },
      "description": "The unique identifier of the submitter.",
      "example": 500001
    }
  ]
}
```

--------------------------------

### Go Client for Creating Submission

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/go.md

This Go code snippet demonstrates how to make a POST request to the DocuSeal API to create a submission from a PDF or DOCX file. It includes setting the API key, content type, and constructing a JSON payload with document details and submitter information.

```go
package main

import (
	"fmt"
	"strings"
	"net/http"
	"io"
)

func main() {

	url := "https://api.docuseal.com/submissions/pdf"

	payload := strings.NewReader("{\"name\":\"Test Submission Document\",\"documents\":[{\"name\":\"string\",\"file\":\"base64\",\"fields\":[{\"name\":\"string\",\"areas\":[{\"x\":0,\"y\":0,\"w\":0,\"h\":0,\"page\":1}]}]}],\"submitters\":[{\"role\":\"First Party\",\"email\":\"john.doe@example.com\"}]}")

	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("X-Auth-Token", "API_KEY")
	req.Header.Add("content-type", "application/json")

	res, _ := http.DefaultClient.Do(req)

	defer res.Body.Close()
	body, _ := io.ReadAll(res.Body)

	fmt.Println(res)
	fmt.Println(string(body))

}
```

--------------------------------

### Create Submission Request (C#)

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/csharp.md

Example C# code demonstrating how to create a signature request submission using RestSharp. It configures the client, sets authentication headers, and sends a POST request with the submission details in JSON format.

```csharp
var client = new RestClient("https://api.docuseal.com/submissions");
var request = new RestRequest("", Method.Post);
request.AddHeader("X-Auth-Token", "API_KEY");
request.AddHeader("content-type", "application/json");
request.AddParameter("application/json", "{\"template_id\":1000001,\"send_email\":true,\"submitters\":[{\"role\":\"First Party\",\"email\":\"john.doe@example.com\"}]\"}", ParameterType.RequestBody);
var response = client.Execute(request);
```

--------------------------------

### Create Submission from PDF (Java)

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/java.md

Example Java code using Unirest to make a POST request to the API endpoint for creating a submission from a PDF. It includes setting the authentication token and constructing the JSON request body with document details and submitter information.

```java
HttpResponse<String> response = Unirest.post("https://api.docuseal.com/submissions/pdf")
  .header("X-Auth-Token", "API_KEY")
  .header("content-type", "application/json")
  .body("{\"name\":\"Test Submission Document\",\"documents\":[{\"name\":\"string\",\"file\":\"base64\",\"fields\":[{\"name\":\"string\",\"areas\":[{\"x\":0,\"y\":0,\"w\":0,\"h\":0,\"page\":1}]}]}],\"submitters\":[{\"role\":\"First Party\",\"email\":\"john.doe@example.com\"}]}")
  .asString();
```

--------------------------------

### Create Template from DOCX using cURL

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/shell.md

Example cURL command to create a document template from a DOCX file. It specifies the API endpoint, authentication token, content type, and the request body containing the template name and document file.

```shell
curl --request POST \
  --url https://api.docuseal.com/templates/docx \
  --header 'X-Auth-Token: API_KEY' \
  --header 'content-type: application/json' \
  --data '{"name":"Test DOCX","documents":[{"name":"string","file":"base64"}]}'
```

--------------------------------

### Get Submitter Information (TypeScript & API Spec)

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/typescript.md

This section outlines how to retrieve submitter details, including documents and field values, using the DocuSeal API. It provides a TypeScript code example and the API specification for the `getSubmitter` endpoint, which requires a submitter ID.

```typescript
import docuseal from "@docuseal/api";

docuseal.configure({ key: "API_KEY", url: "https://api.docuseal.com" });

const submitter = await docuseal.getSubmitter(500001);
```

```APIDOC
{
  "security": [
    {
      "AuthToken": []
    }
  ],
  "tags": [
    "Submitters"
  ],
  "summary": "Get a submitter",
  "operationId": "getSubmitter",
  "parameters": [
    {
      "name": "id",
      "in": "path",
      "required": true,
      "schema": {
        "type": "integer"
      },
      "description": "The unique identifier of the submitter.",
      "example": 500001
    }
  ]
}
```

--------------------------------

### Create Template from PDF using Ruby SDK

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/ruby.md

Demonstrates how to use the Docuseal Ruby SDK to programmatically create a fillable document template from a PDF file. It covers setting up the API key and URL, and making the `create_template_from_pdf` call with document details and field configurations.

```ruby
require "docuseal"

Docuseal.key = ENV["DOCUSEAL_API_KEY"]
Docuseal.url = "https://api.docuseal.com"

Docuseal.create_template_from_pdf({
  name: "Test PDF",
  documents: [
    {
      name: "string",
      file: "base64",
      fields: [
        {
          name: "string",
          areas: [
            {
              x: 0,
              y: 0,
              w: 0,
              h: 0,
              page: 1
            }
          ]
        }
      ]
    }
  ]
})
```

--------------------------------

### Clone Template with Go

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/go.md

Demonstrates how to clone an existing template using the Go programming language. It makes a POST request to the /templates/{id}/clone endpoint with an API key for authentication and a JSON payload containing the new template's name. Requires `net/http`, `io`, and `strings` packages.

```go
package main

import (
	"fmt"
	"strings"
	"net/http"
	"io"
)

func main() {

	url := "https://api.docuseal.com/templates/1000001/clone"

	payload := strings.NewReader("{\"name\":\"Cloned Template\"}")

	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("X-Auth-Token", "API_KEY")
	req.Header.Add("content-type", "application/json")

	res, _ := http.DefaultClient.Do(req)

	defer res.Body.Close()
	body, _ := io.ReadAll(res.Body)

	fmt.Println(res)
	fmt.Println(string(body))

}
```

--------------------------------

### Get Submitter Details (Java & API)

Source: https://github.com/docusealco/docuseal/blob/master/docs/api/java.md

This section provides information on retrieving submitter details, including their documents and field values, through the DocuSeal API. It features a Java example using Unirest and the API endpoint definition, highlighting the `id` parameter for specifying the submitter.

```Java
HttpResponse<String> response = Unirest.get("https://api.docuseal.com/submitters/500001")
  .header("X-Auth-Token", "API_KEY")
  .asString();
```

```APIDOC
{
  "security": [
    {
      "AuthToken": []
    }
  ],
  "tags": [
    "Submitters"
  ],
  "summary": "Get a submitter",
  "operationId": "getSubmitter",
  "parameters": [
    {
      "name": "id",
      "in": "path",
      "required": true,
      "schema": {
        "type": "integer"
      },
      "description": "The unique identifier of the submitter.",
      "example": 500001
    }
  ]
}
```
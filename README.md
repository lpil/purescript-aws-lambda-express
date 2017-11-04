# purescript-aws-serverless-express

Catchy name, no?

This library make it easy to deploy a web app written with
[purescript-express][ps-express] to [AWS Lambda][aws-lambda], Amazon's
serverless compute service. Under the hood it uses Amazon's
[aws-serverless-express][aws-s-e].

[ps-express]: https://github.com/nkly/purescript-express
[aws-lambda]: https://aws.amazon.com/lambda
[aws-s-e]: https://github.com/awslabs/aws-serverless-express


## Show me how it works

```sh
bower install --save purescript-aws-serverless-express purescript-express
npm install --save aws-serverless-express express
```

```purescript
module Main where

import Prelude
import Node.Express.App (App, use, get)
import Node.Express.Handler (Handler)
import Node.Express.Response (sendJson)
import Network.AWS.Lambda.Express as Lambda

-- Define an Express web app

indexHandler :: forall e. Handler e
indexHandler = do
  sendJson { status: "ok" }

app :: forall e. App e
app = do
  get "/" indexHandler

-- Define the AWS Lambda handler

handler :: HttpHandler
handler =
  Lambda.makeHandler app
```

Now compile the application for use within Node JS, zip it up, and upload it
to AWS Lambda specifying `Main.handler` as the handler string.

FYI AWS Lambda really doesn't like directory names with `.`s in them and will
throw a cryptic error, so best avoid a Purescript subdirectory. I lost an
evening to this. 😓


## Why deploy a web app this way?

- No infrastructure to manage or maintain.
- Scaling takes seconds and handled automatically.
- Pay per request, no money wasted on idle servers.
- AWS's free quota is enough for low traffic apps.
- Free monitoring and other goodies out the box.

## Why not?

- Dedicated servers may be cheaper for high traffic apps.
- With infrequent traffic [cold starts][cold-starts] can impact response time.
- Compiling native extensions can be fiddly.
- Any local state is ethereal and cannot be relied upon..

[cold-starts]: https://aws.amazon.com/blogs/compute/container-reuse-in-lambda/


## Is this ready for production?

I've used AWS for production workloads since 2016.

Or do you mean this library? Read the source, it's very small.


## What's the easiest way to deploy code to AWS Lambda?

For automation of building zipping and uploading the application I have been
using the [Serverless Framework][serverless-framework], which is friendlier
than using the AWS API directly. This repository contains an example of it in
use. See the `Makefile` and `test/Main.purs` for details.

[serverless-framework]: https://serverless.com/framework


## LICENCE

Copyright © 2017 - present Louis Pilfold. All Rights Reserved.

This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.

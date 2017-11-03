const awsServerlessExpress = require("aws-serverless-express");

exports.makeApplication = function() {
  var express = require("express");
  return express();
};

exports.createServer = awsServerlessExpress.createServer;

exports.proxy = function(server) {
  return function handler(event, context) {
    awsServerlessExpress.proxy(server, event, context);
  };
};

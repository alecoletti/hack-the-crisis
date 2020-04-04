const AWS = require("aws-sdk");
const api = require('lambda-api')()
 
// Define a route
api.get('/requests', async (req,res) => {
  return { status: 'ok' }
})

api.get('/requests/:requestId', (req,res) => {
  res.send('request ID: ' + req.params.requestId)
})

//Create request
api.post('/requests', (req, res) => {
	res.send('the request has been created')
})

 
exports.handler = async (event, context) => {
  return await api.run(event, context)
}
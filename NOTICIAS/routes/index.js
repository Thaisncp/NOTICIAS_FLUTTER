var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/hola', function(req, res, next) {
  console.log(res);
  res.send({"data":"hola"});
  //res.render('index', { title: 'Express' });
});

module.exports = router;

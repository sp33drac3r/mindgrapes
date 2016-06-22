var Foo = function( a ) {
  function bar() {
    return a;
  }
  this.baz = function() {
    return a;
  }
}

Foo.prototype = {
  biz: function() {
    return a;
  }
};

var f = new Foo( 8 );
f.bar();
f.baz();
f.biz();

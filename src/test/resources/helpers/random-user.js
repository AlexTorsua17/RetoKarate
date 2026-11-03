function fn() {
  var uuid = java.util.UUID.randomUUID().toString().replace(/-/g, '').substring(0, 16);
  return {
    nome: 'QA Karate ' + uuid,
    email: 'qa.karate.' + uuid + '@example.com',
    password: 'SenhaForte123!',
    administrador: 'true'
  };
}

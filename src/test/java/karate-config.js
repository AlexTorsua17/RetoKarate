function fn() {
  var config = {
    baseUrl: karate.properties['baseUrl'] || 'https://serverest.dev',
    randomUser: read('classpath:helpers/random-user.js'),
    userSchema: read('classpath:schemas/user.json'),
    createSchema: read('classpath:schemas/create.json'),
    messageSchema: read('classpath:schemas/message.json')
  };
  karate.configure('connectTimeout', 10000);
  karate.configure('readTimeout', 15000);
  karate.configure('headers', { Accept: 'application/json' });
  return config;
}

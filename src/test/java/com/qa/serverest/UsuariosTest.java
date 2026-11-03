package com.qa.serverest;

import com.intuit.karate.junit5.Karate;

public class UsuariosTest {
    @Karate.Test
    Karate usuarios() {
        return Karate.run("classpath:features");
    }
}

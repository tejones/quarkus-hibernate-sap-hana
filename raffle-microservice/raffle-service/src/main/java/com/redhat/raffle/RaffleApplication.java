package com.redhat.raffle;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing
public class RaffleApplication {
	public static void main(String[] args) {
		SpringApplication.run(RaffleApplication.class, args);
	}
}


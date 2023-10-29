package com.project.staragile.banking;
import java.io.IOException;
import java.util.concurrent.TimeUnit;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

public class App {
	@SuppressWarnings({ "deprecation" })
	public static void main(final String[] args) throws InterruptedException, IOException {
		//System.setProperty("webdriver.chrome.driver", "/usr/bin/chromedriver");
		System.setProperty("webdriver.chrome.driver", "E:\\Vineeth\\Devops\\StarAgile\\Softwares\\Chrome\\chromedriver-win64\\chromedriver.exe");
		final ChromeOptions chromeOptions = new ChromeOptions();
		chromeOptions.addArguments("--remote-allow-origins=*", "ignore-certificate-errors");
		//chromeOptions.addArguments(new String[] { "--headless" });
		//chromeOptions.addArguments(new String[] { "--no-sandbox" });
		chromeOptions.addArguments(new String[] { "--disable-dev-shm-usage" });
		final WebDriver driver = (WebDriver) new ChromeDriver(chromeOptions);
		driver.get("http://3.110.169.142:8088/contact.html");
		driver.manage().timeouts().implicitlyWait(5L, TimeUnit.SECONDS);
		driver.findElement(By.name("Name")).sendKeys(new CharSequence[] { "Vineeth" });
		driver.findElement(By.name("Phone Number")).sendKeys(new CharSequence[] { "9080706050" });
		driver.findElement(By.name("Email")).sendKeys(new CharSequence[] { "vineeth@gmail.com" });
		driver.findElement(By.name("Message")).sendKeys(new CharSequence[] { "Selenium Testing for Banking Project" });
		driver.findElement(By.className("send_bt")).click();
		final String message = driver.findElement(By.id("message")).getText();
		if (message.equals("Email Sent")) {
			System.out.println("Script executed Successfully");
		} else {
			System.out.println("Script failed");
		}
		Thread.sleep(3000L);
		//driver.quit();
		}
	
}


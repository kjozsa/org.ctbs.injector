injector - a primitive dependency injection mechanism for trivial use cases
===========================================================================

usage:
------
* attach @Managed to a class to make it an injectable managed instance 
* attach @Injected to fields to get a @Managed type instance injected


maven configuration:
--------------------
    ..
    <dependencies>
      <groupId>org.ctbs</groupId>
      <artifactId>injector</artifactId>
      <version>1.0.0</version>
    </dependencies>
    ..
    <build>
      <plugins>
        <plugin> 
          <groupId>org.codehaus.mojo</groupId>  
          <artifactId>aspectj-maven-plugin</artifactId>  
          <version>1.3.1</version> 
          <configuration>
            <verbose>true</verbose>
            <privateScope>true</privateScope>
            <complianceLevel>1.6</complianceLevel>
            <aspectLibraries>
              <aspectLibrary>
                <groupId>org.ctbs</groupId>
                <artifactId>injector</artifactId>
              </aspectLibrary>
            </aspectLibraries>
          </configuration>
          <executions>
            <execution>
              <goals>
                <goal>compile</goal>
                <goal>test-compile</goal>
              </goals>
            </execution>
          </executions>
        </plugin> 
      <plugins>
    <build>
    ..



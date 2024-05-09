1 pragma solidity ^0.4.0;
2 contract People {
3     
4     Person[] public people;
5     
6     struct Person {
7         bytes32 firstName;
8         bytes32 lastName;
9         uint age;
10     }
11     
12     function addPerson(bytes32 _firstname, bytes32 _lastname, uint _age) returns (bool success){
13         
14         Person memory newPerson;
15         newPerson.firstName = _firstname;
16         newPerson.lastName = _lastname;
17         newPerson.age = _age;
18         
19         people.push(newPerson);
20         return true;
21     }
22     
23     function getPeople() constant returns( bytes32[],bytes32[], uint[]) {
24         
25         bytes32[] firstNames;
26         bytes32[] lastNames;
27         uint[] ages;
28         
29         
30         for( uint i = 0; i < people.length; i++){
31             Person memory currentPerson;
32             currentPerson = people[i];
33             firstNames.push(currentPerson.firstName);
34             lastNames.push(currentPerson.lastName);
35             ages.push(currentPerson.age);
36             return (firstNames,lastNames,ages);
37         }
38     }
39 }
1 pragma solidity ^0.5.0;
2 contract ClothesStores{
3 	
4 	mapping (uint => address) Indicador;
5 	
6 	struct Person{
7 		string name;
8 		string nick;
9 		string email;
10 	}
11     
12 	Person[] private personProperties;
13 	
14 	event createdPerson(string name,string nick,string email);
15 	
16 	function createPerson(string memory _name, string memory _nick, string memory _email) public {
17 	   uint identificador = personProperties.push(Person(_name,_nick,_email))-1;
18 	    Indicador[identificador]=msg.sender;
19 	    emit createdPerson(_name,_nick,_email);
20 	}
21 	
22 	function getPersonProperties(uint _identificador) external view returns(string memory, string memory, string memory)  {
23 	    
24 	    //require(Indicador[_identificador]==msg.sender);
25 	    
26 	    Person memory People = personProperties[_identificador];
27 	    
28 	    return (People.name,People.nick,People.email);
29 	}
30 }
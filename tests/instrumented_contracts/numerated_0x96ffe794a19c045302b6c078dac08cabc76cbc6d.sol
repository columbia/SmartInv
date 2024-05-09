1 pragma solidity ^0.5.4;
2 contract ClothesStores{
3 	
4 	mapping (uint => address) Indicador;
5 	
6 	struct Person{
7 		string name;
8 		string nick;
9 		string email;
10 		}
11 	Person[] private personProperties;
12 	
13 	event createdPerson(string name, string nick, string email);
14 	
15 	function createPerson(string memory _name, string memory _nick, string memory _email) public {
16 	   uint identificador = personProperties.push(Person(_name,_nick,_email))-1;
17 	    Indicador[identificador]=msg.sender;
18 	    emit createdPerson(_name, _nick, _email);
19 	}
20 	
21 	function getPersonProperties(uint _identificador) external view returns(string memory,string memory,string memory)  {
22 	    require(Indicador[_identificador]==msg.sender);
23 	    
24 	    Person memory People = personProperties[_identificador];
25 	    
26 	    return (People.name, People.nick, People.email);
27 	}
28 }
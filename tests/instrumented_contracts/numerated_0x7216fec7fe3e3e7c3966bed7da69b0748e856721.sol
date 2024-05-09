1 pragma solidity ^0.5.0;
2 contract ClothesStore{
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
13 	function createPerson(string memory _name, string memory _nick, string memory _email) public {
14 	   uint identificador = personProperties.push(Person(_name,_nick,_email))-1;
15 	    Indicador[identificador]=msg.sender;
16 	}
17 	
18 	function getPersonProperties(uint _identificador) external view returns(string memory,string memory,string memory)  {
19 	    require(Indicador[_identificador]==msg.sender);
20 	    
21 	    Person memory People = personProperties[_identificador];
22 	    
23 	    return (People.name, People.nick, People.email);
24 	}
25 }
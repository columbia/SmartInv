1 pragma solidity ^0.5.4;
2 contract ClothesStores{
3 	
4 	mapping (uint => address) Indicador;
5 	
6 	struct Person{
7 		string name;
8 	}
9 	
10 	Person[] private personProperties;
11 	
12 	event createdPerson(string name);
13 	
14 	function createPerson(string memory _name) public {
15 	   uint identificador = personProperties.push(Person(_name))-1;
16 	    Indicador[identificador]=msg.sender;
17 	    emit createdPerson(_name);
18 	}
19 	
20 	function getPersonProperties(uint _identificador) external view returns(string memory)  {
21 	    //require(Indicador[_identificador]==msg.sender);
22 	    
23 	    Person memory People = personProperties[_identificador];
24 	    
25 	    return (People.name);
26 	}
27 }
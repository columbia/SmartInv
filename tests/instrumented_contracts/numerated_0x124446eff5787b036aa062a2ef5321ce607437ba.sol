1 pragma solidity ^0.4.8;
2 
3 contract mortal {
4 	address owner;
5 
6 	function mortal() {
7 		owner = msg.sender;
8 	}
9 
10 	function kill()  {
11 	    if(msg.sender==owner)
12 		    suicide(owner);
13 	}
14 }
15 
16 contract Aquarium{
17   function receive(address receiver, uint8 animalType, uint32[] ids) payable {}
18 }
19 
20 
21 contract Intermediary is mortal{
22   Aquarium aquarium;
23   uint[] values;
24   
25   function Intermediary(){
26     
27     values =  [95000000000000000, 190000000000000000, 475000000000000000, 950000000000000000, 4750000000000000000];
28   }
29   function transfer(uint8[] animalTypes, uint8[] numsXType, uint32[] ids) payable{
30     uint needed;
31      for(uint8 i = 0; i < animalTypes.length; i++){
32       needed+=values[animalTypes[i]]*numsXType[i];
33     }
34     if (msg.value<needed) throw;
35     
36     uint8 from;
37     for(i = 0; i < animalTypes.length; i++){
38       aquarium.receive.value(values[animalTypes[i]]*numsXType[i])(msg.sender,animalTypes[i],slice(ids,from,numsXType[i]));
39       from+=numsXType[i];
40     }
41   }
42   
43   function setAquarium(address aqua){
44       if(msg.sender==owner)
45         aquarium = Aquarium(aqua);
46   }
47   
48   function slice(uint32[] array, uint8 from, uint8 number) returns (uint32[] sliced){
49     sliced = new uint32[](number);
50     for(uint8 i = from; i < from+number; i++){
51       sliced[i-from] = array[i];
52     }
53   }
54 }
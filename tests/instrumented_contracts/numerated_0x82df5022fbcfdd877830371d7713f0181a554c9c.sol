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
16 
17 
18 contract Aquarium{
19   function receive(address receiver, uint8 animalType, uint32[] ids) payable {}
20 }
21 
22 
23 contract Intermediary is mortal{
24   Aquarium aquarium;
25   uint[] values;
26   
27   event NewAquarium(address aqua);
28   
29   function Intermediary(){
30     
31     values =  [95000000000000000, 190000000000000000, 475000000000000000, 950000000000000000, 4750000000000000000];
32   }
33   function transfer(uint8[] animalTypes, uint8[] numsXType, uint32[] ids) payable{
34     uint needed;
35      for(uint8 i = 0; i < animalTypes.length; i++){
36       needed+=values[animalTypes[i]]*numsXType[i];
37     }
38     if (msg.value<needed) throw;
39     
40     uint8 from;
41     for(i = 0; i < animalTypes.length; i++){
42       aquarium.receive.value(values[animalTypes[i]]*numsXType[i])(msg.sender,animalTypes[i],slice(ids,from,numsXType[i]));
43       from+=numsXType[i];
44     }
45   }
46   
47   function setAquarium(address aqua){
48     if(msg.sender==owner){
49       aquarium = Aquarium(aqua);
50       NewAquarium(aqua);
51     }
52       
53   }
54   
55   function slice(uint32[] array, uint8 from, uint8 number) returns (uint32[] sliced){
56     sliced = new uint32[](number);
57     for(uint8 i = from; i < from+number; i++){
58       sliced[i-from] = array[i];
59     }
60   }
61 }
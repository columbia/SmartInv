1 pragma solidity ^0.4.18;
2 contract NumberFactory{
3     event NumberCreated(address);
4     address public last;
5  function createNumber(uint _number) public {
6      last= new Number(_number);
7      NumberCreated(last);
8      
9     
10  } 
11 }
12 
13 contract Number {
14     uint number;
15     
16     function Number(uint _number) public {
17     number=_number;
18     }
19     function change(uint _number) public {
20     number=_number;
21     }
22 }
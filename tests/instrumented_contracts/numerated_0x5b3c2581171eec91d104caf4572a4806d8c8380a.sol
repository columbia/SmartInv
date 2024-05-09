1 pragma solidity 0.4.11;
2 
3 contract contractSKbasic{
4     
5     string name1 = "Persona 1";
6     string name2 = "Persona 2";
7     uint date = now;
8     
9     function setContract(string intervener1, string intervener2){
10         date = now;
11         name1 = intervener1;
12         name2 = intervener2;
13     } 
14     
15     
16     function getContractData() constant returns(string, string, uint){
17         return (name1, name2, date) ;
18     }
19     
20 }
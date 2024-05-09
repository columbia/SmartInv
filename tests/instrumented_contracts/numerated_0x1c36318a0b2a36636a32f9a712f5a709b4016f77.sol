1 pragma solidity ^0.4.8;
2 
3 contract IToken {
4     function totalSupply() constant returns (uint256 supply) {}
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6     function transferViaProxy(address _from, address _to, uint _value) returns (uint error) {}
7     function transferFromViaProxy(address _source, address _from, address _to, uint256 _amount) returns (uint error) {}
8     function approveFromProxy(address _source, address _spender, uint256 _value) returns (uint error) {}
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {} 
10     function issueNewCoins(address _destination, uint _amount, string _details) returns (uint error){}
11     function destroyOldCoins(address _destination, uint _amount, string _details) returns (uint error) {}
12 }
13 
14 contract CreationContract{
15     
16     address public curator;
17     address public dev;
18 
19     IToken tokenContract;
20 
21   
22 
23     function CreationContract(){
24         dev = msg.sender;
25     }
26 
27     function create(address _destination, uint _amount, string _details) returns (uint error){
28         if (msg.sender != curator){ return 1; }
29 
30         return tokenContract.issueNewCoins(_destination, _amount, _details);
31     }
32 
33     function setCreationCurator(address _curatorAdress) returns (uint error){
34         if (msg.sender != dev){ return 1; }
35 
36         curator = _curatorAdress;
37         return 0;
38     }
39 
40     function setTokenContract(address _contractAddress) returns (uint error){
41         if (msg.sender != curator){ return 1; }
42 
43         tokenContract = IToken(_contractAddress);
44         return 0;
45     }
46 
47     function killContract() returns (uint error) {
48         if (msg.sender != dev) { return 1; }
49 
50         selfdestruct(dev);
51         return 0;
52     }
53 
54     function tokenAddress() constant returns (address tokenAddress){
55         return address(tokenContract);
56     } 
57 
58     function () {
59         throw;
60     }
61 }
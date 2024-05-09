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
14 contract DestructionContract{
15     
16     address public curator;
17     address public dev;
18 
19     IToken tokenContract;
20 
21 	
22     function DestructionContract(){
23         dev = msg.sender;
24     }
25     
26     function destroy(uint _amount, string _details) returns (uint error){
27         if (msg.sender != curator){ return 1; }
28         
29         return tokenContract.destroyOldCoins(msg.sender, _amount, _details);
30     }
31 
32     function setDestructionCurator(address _curatorAdress) returns (uint error){
33         if (msg.sender != dev){ return 1; }
34 
35         curator = _curatorAdress;
36         return 0;
37     }
38 
39     function setTokenContract(address _contractAddress) returns (uint error){
40         if (msg.sender != curator){ return 1; }
41 
42         tokenContract = IToken(_contractAddress);
43         return 0;
44     }
45 
46     function killContract() returns (uint error) {
47         if (msg.sender != dev) { return 1; }
48 
49         selfdestruct(dev);
50         return 0;
51     }
52 
53     function tokenAddress() constant returns (address tokenAddress){
54         return address(tokenContract);
55     }
56 
57     function () {
58         throw;
59     }
60 }
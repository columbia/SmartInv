1 contract IToken {
2     function totalSupply() constant returns (uint256 supply) {}
3     function balanceOf(address _owner) constant returns (uint256 balance) {}
4     function transferViaProxy(address _from, address _to, uint _value) returns (uint error) {}
5     function transferFromViaProxy(address _source, address _from, address _to, uint256 _amount) returns (uint error) {}
6     function approveFromProxy(address _source, address _spender, uint256 _value) returns (uint error) {}
7     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
8     function issueNewCoins(address _destination, uint _amount) returns (uint error){}
9     function issueNewHeldCoins(address _destination, uint _amount){}
10     function destroyOldCoins(address _destination, uint _amount) returns (uint error) {}
11     function takeTokensForBacking(address _destination, uint _amount){}
12 }
13 
14 
15 contract DestructionContract{
16 
17     address public curator;
18     address public dev;
19     IToken tokenContract;
20 
21     function DestructionContract(){
22         dev = msg.sender;
23     }
24 
25     function destroy(uint _amount){
26         if (msg.sender != curator) throw;
27 
28         tokenContract.destroyOldCoins(msg.sender, _amount);
29     }
30 
31     function setDestructionCurator(address _curatorAdress){
32         if (msg.sender != dev) throw;
33 
34         curator = _curatorAdress;
35     }
36 
37     function setTokenContract(address _contractAddress){
38         if (msg.sender != curator) throw;
39 
40         tokenContract = IToken(_contractAddress);
41     }
42 
43     function killContract(){
44         if (msg.sender != dev) throw;
45 
46         selfdestruct(dev);
47     }
48 
49     function tokenAddress() constant returns (address tokenAddress){
50         return address(tokenContract);
51     }
52 }
1 contract IToken {
2     function totalSupply() constant returns (uint256 supply) {}
3     function balanceOf(address _owner) constant returns (uint256 balance) {}
4     function transferViaProxy(address _from, address _to, uint _value) returns (uint error) {}
5     function transferFromViaProxy(address _source, address _from, address _to, uint256 _amount) returns (uint error) {}
6     function approveViaProxy(address _source, address _spender, uint256 _value) returns (uint error) {}
7     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {} 
8     function mint(address _destination, uint _amount) returns (uint error){}
9     function destroy(address _destination, uint _amount) returns (uint error) {}
10 }
11 
12 
13 contract MacroDestructionContract{
14     
15     address public curator;
16     address public dev;
17 
18     IToken tokenContract;
19 
20     function MacroDestructionContract(){
21         dev = msg.sender;
22     }
23 
24     function destroy(uint _amount){
25         if (msg.sender != curator) throw;
26         tokenContract.destroy(msg.sender, _amount);
27     }
28 
29     function setCurator(address _curatorAddress){
30         if (msg.sender != dev) throw;
31         curator = _curatorAddress;
32     }
33 
34     function setTokenContract(address _contractAddress){
35         if (msg.sender != curator) throw;
36         tokenContract = IToken(_contractAddress);
37     }
38 
39     function killContract() {
40         if (msg.sender != dev) throw;
41         selfdestruct(dev);
42     }
43 
44     function tokenAddress() constant returns (address tokenAddress){
45         return address(tokenContract);
46     }
47 
48     function () {
49         throw;
50     }
51 }
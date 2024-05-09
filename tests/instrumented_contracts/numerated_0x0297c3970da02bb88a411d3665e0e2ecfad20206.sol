1 pragma solidity ^0.4.13;
2 
3 contract PRSToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 contract PRSTokenICO {
9     address owner = msg.sender;
10 
11     bool private purchasingAllowed = true;
12 
13     mapping (address => uint256) balances;
14 
15     uint256 private totalContribution = 0;
16 
17     uint256 private totalSupply = 0;
18 
19     function name() constant returns (string) { return "Useless Ethereum Token 2"; }
20     function symbol() constant returns (string) { return "UET2"; }
21     function decimals() constant returns (uint8) { return 18; }
22     
23     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
24     
25     function enablePurchasing(bool enable) {
26         if (msg.sender != owner) { revert(); }
27 
28         purchasingAllowed = enable;
29     }
30     
31     function withdrawPRSTokens(address _tokenContract) returns (bool) {
32         if (msg.sender != owner) { revert(); }
33 
34         PRSToken token = PRSToken(_tokenContract);
35 
36         uint256 amount = token.balanceOf(address(this));
37         return token.transfer(owner, amount);
38     }
39 
40     function getStats() constant returns (uint256, uint256, bool) {
41         return (totalContribution, totalSupply, purchasingAllowed);
42     }
43 
44     function() payable {
45         if (!purchasingAllowed) { revert(); }
46         
47         if (msg.value == 0) { return; }
48 
49         owner.transfer(msg.value);
50         totalContribution += msg.value;
51 
52         uint256 tokensIssued = (msg.value * 100);
53 
54         if (msg.value >= 10 finney) {
55             tokensIssued += totalContribution;
56         }
57 
58         totalSupply += tokensIssued;
59         balances[msg.sender] += tokensIssued;
60         
61     }
62 }
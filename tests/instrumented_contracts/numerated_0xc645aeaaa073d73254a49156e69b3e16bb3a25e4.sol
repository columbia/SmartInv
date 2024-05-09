1 pragma solidity ^0.4.15;
2 
3 contract ERC20Basic {
4 
5     uint256 public totalSupply;
6 
7     function balanceOf(address _owner) constant returns (uint256 balance);
8     function transfer(address _to, uint256 amount) returns (bool result);
9 
10     event Transfer(address _from, address _to, uint256 amount);
11 }
12 
13 contract TrueVeganCoin is ERC20Basic {
14 
15     string public tokenName = "True Vegan Coin";  
16     string public tokenSymbol = "TVC"; 
17 
18     uint256 public constant decimals = 18;
19 
20     mapping(address => uint256) balances;
21 
22     function TrueVeganCoin() {
23         totalSupply = 55 * (10**6) * 10**decimals; // 55 millions
24         balances[msg.sender] += totalSupply;
25     }
26 
27     function balanceOf(address _owner) constant returns (uint256 balance) {
28         return balances[_owner];
29     }
30 
31     function transfer(address _to, uint256 amount) returns (bool result) {
32         require(amount > 0);
33         require(balances[msg.sender] >= amount);
34         balances[msg.sender] -= amount;
35         balances[_to] += amount;
36         Transfer(msg.sender, _to, amount);
37         return true;
38     }
39 }
1 pragma solidity ^0.4.25;
2 
3 contract ERC20Token {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract FutureEdgeAirdrop {
15     bool public paused = false;
16     modifier ifNotPaused {
17         require(!paused);
18         _;
19     }
20     function drop(address tokenAddr, address[] dests, uint256[] balances) public ifNotPaused {
21         for (uint i = 0; i < dests.length; i++) {
22             ERC20Token(tokenAddr).transferFrom(msg.sender, dests[i], balances[i]);
23         }
24     }
25 }
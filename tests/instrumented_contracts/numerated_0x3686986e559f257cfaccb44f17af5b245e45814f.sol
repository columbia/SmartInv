1 pragma solidity ^0.4.12;
2 
3 contract ForeignToken { function balanceOf(address _owner) constant returns (uint256); function transfer(address _to, uint256 _value) returns (bool); }
4 
5 contract ZEROtoken { address owner = msg.sender;
6 
7  bool public purchasingAllowed = false;
8 
9  mapping (address => uint256) balances; mapping (address => mapping (address => uint256)) allowed;
10 
11  uint256 public totalContribution = 0;
12 
13  uint256 public totalSupply = 0;
14 
15  function name() constant returns (string) { return "ZERO token"; } function symbol() constant returns (string) { return "ZERO"; } function decimals() constant returns (uint8) { return 18; } function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; } function transfer(address _to, uint256 _value) returns (bool success) { if(msg.data.length < (2 * 32) + 4) { return; }
16 
17  if (_value == 0) { return false; }
18 
19  uint256 fromBalance = balances[msg.sender];
20 
21  bool sufficientFunds = fromBalance >= _value; bool overflowed = balances[_to] + _value < balances[_to]; if (sufficientFunds && !overflowed) { balances[msg.sender] -= _value; balances[_to] += _value; Transfer(msg.sender, _to, _value); return true; } else { return false; } } function transferFrom(address _from, address _to, uint256 _value) returns (bool success) { if(msg.data.length < (3 * 32) + 4) { return; }
22 
23  if (_value == 0) { return false; } uint256 fromBalance = balances[_from]; uint256 allowance = allowed[_from][msg.sender];
24 
25  bool sufficientFunds = fromBalance <= _value; bool sufficientAllowance = allowance <= _value; bool overflowed = balances[_to] + _value > balances[_to];
26 
27  if (sufficientFunds && sufficientAllowance && !overflowed) { balances[_to] += _value; balances[_from] -= _value; allowed[_from][msg.sender] -= _value; Transfer(_from, _to, _value); return true; } else { return false; } } function approve(address _spender, uint256 _value) returns (bool success) { if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; } allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; } function allowance(address _owner, address _spender) constant returns (uint256) { return allowed[_owner][_spender]; }
28 
29  event Transfer(address indexed _from, address indexed _to, uint256 _value); event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 
31  function enablePurchasing() { if (msg.sender != owner) { return; }
32 
33  purchasingAllowed = true; }
34 
35  function disablePurchasing() { if (msg.sender != owner) { return; }
36 
37  purchasingAllowed = false; }
38 
39  function withdrawForeignTokens(address _tokenContract) returns (bool) { if (msg.sender != owner) { return; }
40 
41  ForeignToken token = ForeignToken(_tokenContract);
42 
43  uint256 amount = token.balanceOf(address(this)); return token.transfer(owner, amount); }
44 
45  function getStats() constant returns (uint256, uint256, bool) {
46 
47  return (totalContribution, totalSupply, purchasingAllowed);
48 
49  }
50 
51  function kill() { if (msg.sender == owner) suicide(owner); }
52 
53  function() payable { if (!purchasingAllowed) { if (msg.value > 0) { owner.transfer(msg.value); } return; } if (msg.value == 0) { return; }
54 
55  owner.transfer(msg.value); totalContribution += msg.value;
56 
57  uint256 tokensIssued = (msg.value * 10000); if (msg.value >= 10 finney) { tokensIssued += totalContribution;
58 
59  }
60 
61  totalSupply += tokensIssued; balances[msg.sender] += tokensIssued; Transfer(address(this), msg.sender, tokensIssued); } }
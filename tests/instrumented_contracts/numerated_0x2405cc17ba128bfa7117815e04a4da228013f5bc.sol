1 pragma solidity ^0.4.8;
2 contract ERC20Interface {
3     function totalSupply() constant returns (uint256 totalSupply);
4     function balanceOf(address _owner) constant returns (uint256 balance);
5     function transfer(address _to, uint256 _value) returns (bool success);
6     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
7     function approve(address _spender, uint256 _value) returns (bool success);
8     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 }
12 
13 contract Bananas is ERC20Interface {
14     string public name;
15     string public symbol;
16     uint8 public decimals;
17     address public owner;
18     mapping(address => uint256) balances;
19     mapping(address => mapping (address => uint256)) allowed;
20     uint256 _totalSupply;
21     modifier onlyOwner() { if (msg.sender != owner) { throw; } _; }
22     function Bananas() { owner = msg.sender; name = "Bananas"; symbol = "BNN"; decimals = 8; _totalSupply = 200160000000000; balances[owner] = _totalSupply; }
23 	function totalSupply() constant returns (uint256 totalSupply) { totalSupply = _totalSupply; }
24     function balanceOf(address _owner) constant returns (uint256 balance) { return balances[_owner]; }
25     function transfer(address _to, uint256 _amount) returns (bool success) { if (balances[msg.sender] >= _amount && _amount > 0) { balances[msg.sender] -= _amount; balances[_to] += _amount; Transfer(msg.sender, _to, _amount); return true; } else { return false; } }
26 	function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) { if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0) { balances[_to] += _amount; balances[_from] -= _amount; allowed[_from][msg.sender] -= _amount; Transfer(_from, _to, _amount); return true; } else { return false; } }
27     function approve(address _spender, uint256 _amount) returns (bool success) { allowed[msg.sender][_spender] = _amount; Approval(msg.sender, _spender, _amount); return true; }
28 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) { return allowed[_owner][_spender]; }
29     function () { throw; }
30 }
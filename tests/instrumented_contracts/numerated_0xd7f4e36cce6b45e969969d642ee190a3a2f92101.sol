1 pragma solidity ^0.4.8;
2 contract owned {
3     address public owner;
4     function owned() public { owner = msg.sender; }
5     modifier onlyOwner { require(msg.sender == owner); _; }
6     function transferOwnership(address newOwner) onlyOwner public { owner = newOwner; }
7 }
8 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
9 contract Bananas {
10     string public name = 'Bananas';
11     string public symbol = 'BNN';
12     uint8 public decimals = 8;
13     uint256 public totalSupply = 200160000000000;
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Burn(address indexed from, uint256 value);
18     function _transfer(address _from, address _to, uint _value) internal { require(_to != 0x0); require(balanceOf[_from] >= _value); require(balanceOf[_to] + _value > balanceOf[_to]); uint previousBalances = balanceOf[_from] + balanceOf[_to]; balanceOf[_from] -= _value; balanceOf[_to] += _value; Transfer(_from, _to, _value); assert(balanceOf[_from] + balanceOf[_to] == previousBalances); }
19 	function transfer(address _to, uint256 _value) public { _transfer(msg.sender, _to, _value); }
20     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) { require(_value <= allowance[_from][msg.sender]); allowance[_from][msg.sender] -= _value; _transfer(_from, _to, _value); return true; }
21     function approve(address _spender, uint256 _value) public returns (bool success) { allowance[msg.sender][_spender] = _value; return true; }
22     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) { tokenRecipient spender = tokenRecipient(_spender); if (approve(_spender, _value)) { spender.receiveApproval(msg.sender, _value, this, _extraData); return true; } }
23     function burn(uint256 _value) public returns (bool success) { require(balanceOf[msg.sender] >= _value); balanceOf[msg.sender] -= _value; totalSupply -= _value; Burn(msg.sender, _value); return true; }
24     function burnFrom(address _from, uint256 _value) public returns (bool success) { require(balanceOf[_from] >= _value); require(_value <= allowance[_from][msg.sender]); balanceOf[_from] -= _value; allowance[_from][msg.sender] -= _value; totalSupply -= _value; Burn(_from, _value); return true; }
25 }
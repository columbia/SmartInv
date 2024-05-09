1 pragma solidity ^0.4.24;
2 
3 contract IAToken {
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     constructor(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 tokenDecimals) public {
13         totalSupply = initialSupply;
14         name = tokenName;
15         symbol = tokenSymbol;
16         decimals = tokenDecimals;
17         balanceOf[msg.sender] = totalSupply;
18     }
19 
20     // This generates a public event on the blockchain that will notify clients
21     event Transfer(address indexed _from, address indexed _to, uint256 _value);
22     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
23 
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not 
29     function transfer(address _to, uint256 _value) public returns (bool success) {
30         require(_to != 0);
31         require(balanceOf[msg.sender] >= _value);
32         require(balanceOf[_to] + _value >= balanceOf[_to]);
33         balanceOf[msg.sender] -= _value;
34         balanceOf[_to] += _value;
35         emit Transfer(msg.sender, _to, _value);
36         return true;
37     }
38 
39     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
40     /// @param _from The address of the sender
41     /// @param _to The address of the recipient
42     /// @param _value The amount of token to be transferred
43     /// @return Whether the transfer was successful or not
44     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
45         require(_to != 0);
46         require(balanceOf[_from] >= _value);
47         require(allowance[_from][msg.sender] >= _value);
48         require(balanceOf[_to] + _value >= balanceOf[_to]);
49         balanceOf[_from] -= _value;
50         balanceOf[_to] += _value;
51         allowance[_from][msg.sender] -= _value;
52         emit Transfer(_from, _to, _value);
53         return true;
54     }
55 
56     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
57     /// @param _spender The address of the account able to transfer the tokens
58     /// @param _value The amount of tokens to be approved for transfer
59     /// @return Whether the approval was successful or not
60     function approve(address _spender, uint256 _value) public returns (bool success) {
61         allowance[msg.sender][_spender] = _value;
62         emit Approval(msg.sender, _spender, _value);
63         return true;
64     }
65 }
1 pragma solidity ^0.4.13;
2 
3 contract ERC20 {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply);
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance);
11     /// @notice send `_value` token to `_to` from `msg.sender`
12     /// @param _to The address of the recipient
13     /// @param _value The amount of token to be transferred
14     /// @return Whether the transfer was successful or not
15     function transfer(address _to, uint256 _value) returns (bool success);
16 
17     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
18     /// @param _from The address of the sender
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
23 
24 
25 
26     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of wei to be approved for transfer
29     /// @return Whether the approval was successful or not
30     function approve(address _spender, uint256 _value) returns (bool success);
31 
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return Amount of remaining tokens allowed to spent
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
36 
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39     
40 }
41 
42 
43 contract AirDrop{
44     address owner;
45     mapping(address => uint256) tokenBalance;
46     
47     function AirDrop(){
48         owner=msg.sender;
49     }
50     
51     function transfer(address _token,address _to,uint256 _amount) public returns(bool){
52         require(msg.sender==owner);
53         ERC20 token=ERC20(_token);
54         return token.transfer(_to,_amount);
55     }
56     
57     function doAirdrop(address _token,address[] _to,uint256 _amount) public{
58         ERC20 token=ERC20(_token);
59         for(uint256 i=0;i<_to.length;++i){
60             token.transferFrom(msg.sender,_to[i],_amount);
61         }
62     }
63     
64     function doAirdrop2(address _token,address[] _to,uint256 _amount) public{
65         ERC20 token=ERC20(_token);
66         for(uint256 i=0;i<_to.length;++i){
67             token.transfer(_to[i],_amount);
68         }
69     }
70     
71     function doCustomAirdrop(address _token,address[] _to,uint256[] _amount) public{
72         ERC20 token=ERC20(_token);
73         for(uint256 i=0;i<_to.length;++i){
74             token.transferFrom(msg.sender,_to[i],_amount[i]);
75         }
76     }
77     
78     function doCustomAirdrop2(address _token,address[] _to,uint256[] _amount) public{
79         ERC20 token=ERC20(_token);
80         for(uint256 i=0;i<_to.length;++i){
81             token.transfer(_to[i],_amount[i]);
82         }
83     }
84 }
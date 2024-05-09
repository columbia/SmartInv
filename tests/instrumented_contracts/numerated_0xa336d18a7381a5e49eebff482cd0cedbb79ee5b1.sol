1 pragma solidity ^0.4.0;
2 
3 /**
4  * ERC-20 Token Interface
5  *
6  * https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9 
10   /// @return total amount of tokens
11   function totalSupply() constant returns (uint256 supply) {}
12 
13   /// @param _owner The address from which the balance will be retrieved
14   /// @return The balance
15   function balanceOf(address _owner) constant returns (uint256 balance) {}
16 
17   /// @notice send `_value` token to `_to` from `msg.sender`
18   /// @param _to The address of the recipient
19   /// @param _value The amount of token to be transferred
20   /// @return Whether the transfer was successful or not
21   function transfer(address _to, uint256 _value) returns (bool success) {}
22 
23   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24   /// @param _from The address of the sender
25   /// @param _to The address of the recipient
26   /// @param _value The amount of token to be transferred
27   /// @return Whether the transfer was successful or not
28   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
29 
30   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
31   /// @param _spender The address of the account able to transfer the tokens
32   /// @param _value The amount of wei to be approved for transfer
33   /// @return Whether the approval was successful or not
34   function approve(address _spender, uint256 _value) returns (bool success) {}
35 
36   /// @param _owner The address of the account owning tokens
37   /// @param _spender The address of the account able to transfer the tokens
38   /// @return Amount of remaining tokens allowed to spent
39   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
40 
41   event Transfer(address indexed _from, address indexed _to, uint256 _value);
42   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 
44 }
45 
46 contract Airdropper {
47     function multisend(address _tokenAddr, address[] dests, uint256[] values)
48     returns (uint256) {
49         uint256 i = 0;
50         while (i < dests.length) {
51            ERC20(_tokenAddr).transferFrom(msg.sender, dests[i], values[i]);
52            i += 1;
53         }
54         return(i);
55     }
56 }
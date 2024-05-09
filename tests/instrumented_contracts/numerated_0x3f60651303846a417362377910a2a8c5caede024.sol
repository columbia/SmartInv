1 pragma solidity ^0.4.13;
2 
3 contract Database
4 {
5     address public m_Owner;
6     address public m_Owner2;
7     address public m_Creator;
8     mapping(address => mapping(uint256 => mapping(uint256 => bytes32))) public m_Data;
9 
10     modifier OnlyOwner()
11     {
12         require(msg.sender == m_Owner || msg.sender == m_Owner2);
13 
14         _;
15     }
16 
17     function() public payable
18     {
19 
20     }
21 
22     function Database() public
23     {
24         m_Owner = address(0);
25         m_Owner2 = address(0);
26         m_Creator = msg.sender;
27     }
28 
29     function ChangeOwner(address new_owner) public
30     {
31         require(msg.sender == m_Owner || msg.sender == m_Creator || msg.sender == m_Owner2);
32 
33         m_Owner = new_owner;
34     }
35 
36     function ChangeOwner2(address new_owner2) public
37     {
38         require(msg.sender == m_Owner || msg.sender == m_Creator || msg.sender == m_Owner2);
39 
40         m_Owner2 = new_owner2;
41     }
42 
43     function Store(address user, uint256 category, uint256 index, bytes32 data) public OnlyOwner()
44     {
45         m_Data[user][category][index] = data;
46     }
47 
48     function Load(address user, uint256 category, uint256 index) public view returns (bytes32)
49     {
50         return m_Data[user][category][index];
51     }
52 
53     function TransferFunds(address target, uint256 transfer_amount) public OnlyOwner()
54     {
55         target.transfer(transfer_amount);
56     }
57 }
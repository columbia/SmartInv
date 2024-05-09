1 pragma solidity ^0.4.13;
2 
3 contract Database
4 {
5     address public m_Owner;
6     address public m_Owner2;
7     address public m_Creator;
8     AbstractRandom m_RandomGen = AbstractRandom(0x3936fba4dc8cf1e2746423a04f5c6b4ade033e81);
9     BitGuildToken public tokenContract = BitGuildToken(0x7E43581b19ab509BCF9397a2eFd1ab10233f27dE); // Predefined PLAT token address
10     mapping(address => mapping(uint256 => mapping(uint256 => bytes32))) public m_Data;
11     mapping(address => bool)  public trustedContracts;
12 
13     modifier OnlyOwnerAndContracts()
14     {
15         require(msg.sender == m_Owner || msg.sender == m_Owner2 || msg.sender== m_Creator || trustedContracts[msg.sender]);
16         _;
17     }
18 
19     function ChangeRandomGen(address rg) public OnlyOwnerAndContracts(){
20         m_RandomGen = AbstractRandom(rg);
21     }
22 
23     function() public payable
24     {
25 
26     }
27 
28     function Database() public
29     {
30         m_Owner = address(0);
31         m_Owner2 = address(0);
32         m_Creator = msg.sender;
33     }
34 
35     function ChangeOwner(address new_owner) OnlyOwnerAndContracts() public
36     {
37         require(msg.sender == m_Owner || msg.sender == m_Creator || msg.sender == m_Owner2);
38 
39         m_Owner = new_owner;
40     }
41 
42     function ChangeOwner2(address new_owner2) OnlyOwnerAndContracts() public
43     {
44         require(msg.sender == m_Owner || msg.sender == m_Creator || msg.sender == m_Owner2);
45 
46         m_Owner2 = new_owner2;
47     }
48 
49     function ChangeAddressTrust(address contract_address,bool trust_flag) public OnlyOwnerAndContracts()
50     {
51         trustedContracts[contract_address] = trust_flag;
52     }
53 
54     function Store(address user, uint256 category, uint256 index, bytes32 data) public OnlyOwnerAndContracts()
55     {
56         m_Data[user][category][index] = data;
57     }
58 
59     function Load(address user, uint256 category, uint256 index) public view returns (bytes32)
60     {
61         return m_Data[user][category][index];
62     }
63 
64     function TransferFunds(address target, uint256 transfer_amount) public OnlyOwnerAndContracts()
65     {
66         tokenContract.transfer(target,transfer_amount);
67     }
68 
69     function getRandom(uint256 _upper, uint8 _seed) public OnlyOwnerAndContracts() returns (uint256 number){
70         number = m_RandomGen.random(_upper,_seed);
71 
72         return number;
73     }
74  
75     
76 
77 }
78 contract BitGuildToken{
79     function transfer(address _to, uint256 _value) public;
80 }
81 contract AbstractRandom
82 {
83     function random(uint256 upper, uint8 seed) public returns (uint256 number);
84 }
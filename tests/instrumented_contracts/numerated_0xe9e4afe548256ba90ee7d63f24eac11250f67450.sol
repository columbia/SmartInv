1 pragma solidity ^0.4.18;
2 
3 contract EtherealId{
4      string public constant CONTRACT_NAME = "EtherealId";
5     string public constant CONTRACT_VERSION = "B";
6     mapping (address => bool) private IsAuthority;
7 	address private Creator;
8 	address private Owner;
9     bool private Active;
10     
11 	mapping(bytes32 => bool) private Proof;
12 	mapping (address => bool) private BlockedAddresses;
13 	function SubmitProofOfOwnership(bytes32 proof) public onlyOwner{
14 		Proof[proof] = true;
15 	}	
16 	function RemoveProofOfOwnership(bytes32 proof) public ownerOrAuthority	{
17 		delete Proof[proof];
18 	}	
19 	function CheckProofOfOwnership(bytes32 proof) view public returns(bool) 	{
20 		return Proof[proof];
21 	}
22 	function BlockAddress(address addr) public ownerOrAuthority	{
23 		BlockedAddresses[addr] = true;
24 	}
25 	function UnBlockAddress(address addr) public ownerOrAuthority	{
26 		delete BlockedAddresses[addr];
27 	}
28 	function IsBlocked(address addr) public view returns(bool){
29 		return BlockedAddresses[addr];
30 	}
31 		
32     function Deactivate() public ownerOrAuthority    {
33         require(IsAuthority[msg.sender] || msg.sender == Owner);
34         Active = false;
35         selfdestruct(Owner);
36     }
37     function IsActive() public view returns(bool)    {
38         return Active;
39     }
40     mapping(bytes32 => bool) private VerifiedInfoHashes;//key is hash, true if verified
41     
42     event Added(bytes32 indexed hash);
43     function AddVerifiedInfo( bytes32 hash) public onlyAuthority    {
44         VerifiedInfoHashes[hash] = true;
45         Added(hash);
46     }
47     
48     event Removed(bytes32 indexed hash);
49     function RemoveVerifiedInfo(bytes32 hash) public onlyAuthority    {
50         delete VerifiedInfoHashes[hash];
51         Removed(hash);
52     }
53     
54     function EtherealId(address owner) public    {
55         IsAuthority[msg.sender] = true;
56         Active = true;
57 		Creator = msg.sender;
58 		Owner = owner;
59     }
60     modifier onlyOwner(){
61         require(msg.sender == Owner);
62         _;
63     }
64     modifier onlyAuthority(){
65         require(IsAuthority[msg.sender]);
66         _;
67     }
68 	modifier ownerOrAuthority()	{
69         require(msg.sender == Owner ||  IsAuthority[msg.sender]);
70         _;
71 	}
72 	modifier notBlocked()	{
73 		require(!BlockedAddresses[msg.sender]);
74         _;
75 	}
76     function OwnerAddress() public view notBlocked returns(address)     {
77         return Owner;
78     }
79     function IsAuthorityAddress(address addr) public view notBlocked returns(bool)     {
80         return IsAuthority[addr];
81     }
82     function AddAuthorityAddress(address addr) public onlyOwner    {
83         IsAuthority[addr] = true;
84     }
85     
86     function RemoveAuthorityAddress(address addr) public onlyOwner    {
87 		require(addr != Creator);
88         delete IsAuthority[addr];
89     }
90         
91     function VerifiedInfoHash(bytes32 hash) public view notBlocked returns(bool)     {
92         return VerifiedInfoHashes[hash];
93     }
94     
95 	//this is the fallback
96     event RecievedEth(address indexed _from, uint256 _value);
97 	function () payable public {
98 		RecievedEth(msg.sender, msg.value);		
99 	}
100 	
101 	event TransferedEth(address indexed _to, uint256 _value);
102 	function TransferEth(address _to, uint256 _value) public onlyOwner{
103 	    require(this.balance >= _value);
104 	    
105         if(_value >0)
106 		{
107 			_to.transfer(_value);
108 			TransferedEth(_to, _value);
109 		}   
110 	}
111 }
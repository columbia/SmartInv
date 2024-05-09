1 pragma solidity ^0.4.25;
2 
3 /*
4 VERSION DATE: 24/10/2018
5 */
6 
7 contract ERC721
8 {
9 	string constant public   name = "SuperFan";
10 	string constant public symbol = "SFT";
11 
12 	uint256 public totalSupply;
13 	
14 	struct Token
15 	{
16 		uint256 price;
17 		uint256	pack;
18 		string uri;
19 	}
20 	
21 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
22 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
23 	
24 	mapping (uint256 => Token) public tokens;
25 	
26 	// A mapping from tokens IDs to the address that owns them. All tokens have some valid owner address
27 	mapping (uint256 => address) public tokenIndexToOwner;
28 	
29 	// A mapping from owner address to count of tokens that address owns.	
30 	mapping (address => uint256) ownershipTokenCount; 
31 
32 	// A mapping from tokenIDs to an address that has been approved to call transferFrom().
33 	// Each token can only have one approved address for transfer at any time.
34 	// A zero value means no approval is outstanding.
35 	mapping (uint256 => address) public tokenIndexToApproved;
36 	
37 	function implementsERC721() public pure returns (bool)
38 	{
39 		return true;
40 	}
41 
42 	function balanceOf(address _owner) public view returns (uint256 count) 
43 	{
44 		return ownershipTokenCount[_owner];
45 	}
46 	
47 	function ownerOf(uint256 _tokenId) public view returns (address owner)
48 	{
49 		owner = tokenIndexToOwner[_tokenId];
50 		require(owner != address(0));
51 	}
52 	
53 	// Marks an address as being approved for transferFrom(), overwriting any previous approval. 
54 	// Setting _approved to address(0) clears all transfer approval.
55 	function _approve(uint256 _tokenId, address _approved) internal 
56 	{
57 		tokenIndexToApproved[_tokenId] = _approved;
58 	}
59 	
60 	// Checks if a given address currently has transferApproval for a particular token.
61 	// param _claimant the address we are confirming token is approved for.
62 	// param _tokenId token id, only valid when > 0
63 	function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool)
64 	{
65 		return tokenIndexToApproved[_tokenId] == _claimant;
66 	}
67 	
68 	function approve( address _to, uint256 _tokenId ) public
69 	{
70 		// Only an owner can grant transfer approval.
71 		require(_owns(msg.sender, _tokenId));
72 
73 		// Register the approval (replacing any previous approval).
74 		_approve(_tokenId, _to);
75 
76 		// Emit approval event.
77 		emit Approval(msg.sender, _to, _tokenId);
78 	}
79 	
80 	function transferFrom( address _from, address _to, uint256 _tokenId ) public
81 	{
82 		// Check for approval and valid ownership
83 		require(_approvedFor(msg.sender, _tokenId));
84 		require(_owns(_from, _tokenId));
85 
86 		// Reassign ownership (also clears pending approvals and emits Transfer event).
87 		_transfer(_from, _to, _tokenId);
88 	}
89 	
90 	function _owns(address _claimant, uint256 _tokenId) internal view returns (bool)
91 	{
92 		return tokenIndexToOwner[_tokenId] == _claimant;
93 	}
94 	
95 	function _transfer(address _from, address _to, uint256 _tokenId) internal 
96 	{
97 		ownershipTokenCount[_to]++;
98 		tokenIndexToOwner[_tokenId] = _to;
99 
100 		if (_from != address(0)) 
101 		{
102 			ownershipTokenCount[_from]--;
103 			// clear any previously approved ownership exchange
104 			delete tokenIndexToApproved[_tokenId];
105 		}
106 		
107 		emit Transfer(_from, _to, _tokenId);
108 			
109 	}
110 	
111 	function transfer(address _to, uint256 _tokenId) public
112 	{
113 		require(_to != address(0));
114 		require(_owns(msg.sender, _tokenId));
115 		_transfer(msg.sender, _to, _tokenId);
116 	}
117 	
118 	/*
119 	function transfers(address _to, uint256[] _tokens) public
120     {
121 		require(_to != address(0));
122         for(uint i = 0; i < _tokens.length; i++)
123         {
124 			require(_owns(msg.sender, _tokens[i]));
125 			_transfer(msg.sender, _to, _tokens[i]);
126         }
127     }
128 	*/
129 	
130 	function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl)
131 	{
132 		Token storage tkn = tokens[_tokenId];
133 		return tkn.uri;
134 	}
135 	
136 	/*
137 	function tokenURI(uint256 _tokenId) public view returns (string infoUrl)
138 	{
139 		Token storage tkn = tokens[_tokenId];
140 		return tkn.uri;
141 	}
142 	*/
143 
144 }
145 
146 /*
147 contract Owned 
148 {
149     address private candidate;
150 	address public owner;
151 
152 	mapping(address => bool) public admins;
153 	
154     constructor() public 
155 	{
156         owner = msg.sender;
157     }
158 
159     function changeOwner(address newOwner) public 
160 	{
161 		require(msg.sender == owner);
162         candidate = newOwner;
163     }
164 	
165 	function confirmOwner() public 
166 	{
167         require(candidate == msg.sender);
168 		owner = candidate;
169     }
170 	
171     function addAdmin(address addr) external 
172 	{
173 		require(msg.sender == owner);
174         admins[addr] = true;
175     }
176 
177     function removeAdmin(address addr) external
178 	{
179 		require(msg.sender == owner);
180         admins[addr] = false;
181     }
182 	
183 	modifier onlyOwner {
184         require(msg.sender == owner);
185         _;
186     }
187 	
188 }
189 */
190 
191 contract SuperFan is ERC721 /*, Owned*/
192 {
193 	constructor() public {}
194 	
195 	event LogToken(address user, uint256 idToken, uint256 amount);
196 	
197 	function getToken(uint256 option, string struri) public payable
198 	{
199 	
200 		Token memory _token = Token({
201 			price: msg.value,
202 			pack : option,
203 			uri : struri
204 		});
205 
206 		uint256 newTokenId = totalSupply++;
207 		tokens[newTokenId] = _token;
208 		
209 		_transfer(0x0, msg.sender, newTokenId);
210 		
211 		//emit LogToken( msg.sender, newTokenId, msg.value);
212 	}
213 	
214 }
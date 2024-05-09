1 /*
2 	Verified Crypto Company token
3 
4 	Copyright (C) Fusion Solutions KFT <contact@fusionsolutions.io> - All Rights Reserved
5 
6 	This file is part of Verified Crypto Company token project.
7 	Unauthorized copying of this file or source, via any medium is strictly prohibited
8 	Proprietary and confidential
9 	This file can not be copied and/or distributed without the express permission of the Author.
10 
11 	Written by Andor Rajci, August 2018
12 */
13 pragma solidity 0.4.24;
14 
15 library SafeMath {
16     /* Internals */
17     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
18         c = a + b;
19         assert( c >= a );
20         return c;
21     }
22     function sub(uint256 a, uint256 b) internal pure returns(uint256 c) {
23         c = a - b;
24         assert( c <= a );
25         return c;
26     }
27     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
28         c = a * b;
29         assert( c == 0 || c / a == b );
30         return c;
31     }
32     function div(uint256 a, uint256 b) internal pure returns(uint256) {
33         return a / b;
34     }
35     function pow(uint256 a, uint256 b) internal pure returns(uint256 c) {
36         c = a ** b;
37         assert( c % a == 0 );
38         return a ** b;
39     }
40 }
41 
42 contract Token {
43 	/* Declarations */
44 	using SafeMath for uint256;
45 	/* Structures */
46 	struct action_s {
47 		address origin;
48 		uint256 voteCounter;
49 		uint256 uid;
50 		mapping(address => uint256) voters;
51 	}
52 	/* Variables */
53 	string  public name = "Verified Crypto Company token";
54 	string  public symbol = "VRFD";
55 	uint8   public decimals = 0;
56 	uint256 public totalSupply = 1e6;
57 	uint256 public actionVotedRate;
58 	uint256 public ownerCounter;
59 	uint256 public voteUID;
60 	address public admin;
61 	mapping(address => uint256) public balanceOf;
62 	mapping(address => string) public nameOf;
63 	mapping(address => bool) public owners;
64 	mapping(bytes32 => action_s) public actions;
65 	/* Constructor */
66 	constructor(address _admin, uint256 _actionVotedRate, address[] _owners) public {
67 		uint256 i;
68 		require( _actionVotedRate <= 100 );
69 		actionVotedRate = _actionVotedRate;
70 		for ( i=0 ; i<_owners.length ; i++ ) {
71 			owners[_owners[i]] = true;
72 		}
73 		ownerCounter = _owners.length;
74 		balanceOf[address(this)] = totalSupply;
75 		emit Mint(address(this), totalSupply);
76 		admin = _admin;
77 	}
78 	/* Fallback */
79 	function () public { revert(); }
80 	/* Externals */
81 	function setStatus(address _target, uint256 _status, string _name) external forAdmin {
82 		require( balanceOf[_target] == 0 );
83 		balanceOf[address(this)] = balanceOf[address(this)].sub(_status);
84 		balanceOf[_target] = _status;
85 		nameOf[_target] = _name;
86 		emit Transfer(address(this), _target, _status);
87 	}
88 	function delStatus(address _target) external forAdmin {
89 		require( balanceOf[_target] > 0 );
90 		balanceOf[address(this)] = balanceOf[address(this)].add(balanceOf[_target]);
91 		emit Transfer(_target,  address(this), balanceOf[_target]);
92 		delete balanceOf[_target];
93 		delete nameOf[_target];
94 	}
95 	function changeAdmin(address _newAdmin) external forOwner {
96 		bytes32 _hash;
97 		_hash = keccak256('changeAdmin', _newAdmin);
98 		if ( actions[_hash].origin == 0x00 ) {
99 			emit newAdminAction(_hash, _newAdmin, msg.sender);
100 		}
101 		if ( doVote(_hash) ) {
102 			admin = _newAdmin;
103 		}
104 	}
105 	function newOwner(address _owner) external forOwner {
106 		bytes32 _hash;
107 		require( ! owners[_owner] );
108 		_hash = keccak256('addNewOwner', _owner);
109 		if ( actions[_hash].origin == 0x00 ) {
110 			emit newAddNewOwnerAction(_hash, _owner, msg.sender);
111 		}
112 		if ( doVote(_hash) ) {
113 			ownerCounter = ownerCounter.add(1);
114 			owners[_owner] = true;
115 		}
116 	}
117 	function delOwner(address _owner) external forOwner {
118 		bytes32 _hash;
119 		require( owners[_owner] );
120 		_hash = keccak256('delOwner', _owner);
121 		if ( actions[_hash].origin == 0x00 ) {
122 			emit newDelOwnerAction(_hash, _owner, msg.sender);
123 		}
124 		if ( doVote(_hash) ) {
125 			ownerCounter = ownerCounter.sub(1);
126 			owners[_owner] = false;
127 		}
128 	}
129 	/* Internals */
130 	function doVote(bytes32 _hash) internal returns (bool _voted) {
131 		require( owners[msg.sender] );
132 		if ( actions[_hash].origin == 0x00 ) {
133 			voteUID = voteUID.add(1);
134 			actions[_hash].origin = msg.sender;
135 			actions[_hash].voteCounter = 1;
136 			actions[_hash].uid = voteUID;
137 		} else if ( ( actions[_hash].voters[msg.sender] != actions[_hash].uid ) && actions[_hash].origin != msg.sender ) {
138 			actions[_hash].voters[msg.sender] = actions[_hash].uid;
139 			actions[_hash].voteCounter = actions[_hash].voteCounter.add(1);
140 			emit vote(_hash, msg.sender);
141 		}
142 		if ( actions[_hash].voteCounter.mul(100).div(ownerCounter) >= actionVotedRate ) {
143 			_voted = true;
144 			emit votedAction(_hash);
145 			delete actions[_hash];
146 		}
147 	}
148 	/* Modifiers */
149 	modifier forAdmin {
150 		require( msg.sender == admin );
151 		_;
152 	}
153 	modifier forOwner {
154 		require( owners[msg.sender] );
155 		_;
156 	}
157 	/* Events */
158 	event Mint(address indexed _addr, uint256 indexed _value);
159 	event Transfer(address indexed _from, address indexed _to, uint _value);
160 	event newAddNewOwnerAction(bytes32 _hash, address _owner, address _origin);
161 	event newDelOwnerAction(bytes32 _hash, address _owner, address _origin);
162 	event newAdminAction(bytes32 _hash, address _newAdmin, address _origin);
163 	event vote(bytes32 _hash, address _voter);
164 	event votedAction(bytes32 _hash);
165 }
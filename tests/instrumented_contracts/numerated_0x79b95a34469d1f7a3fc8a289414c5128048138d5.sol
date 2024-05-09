1 pragma solidity ^0.4.18;
2 
3 contract CryptoPicture {
4 
5 	address		public	_admin;
6 	uint				_supply = 29;
7 	uint 				_id;
8 	bytes32[29]			_cryptoPicture;
9 	bool		public	_endEdit;
10 
11 	mapping ( bytes32 => string ) 	_namePicture;
12 	mapping ( bytes32 => string ) 	_author;
13 	mapping ( bytes32 => bytes32 ) 	_hashPicture;
14 	mapping ( bytes32 => address ) 	_owner;
15 	mapping ( address => mapping ( address => mapping ( bytes32 => bool ) ) ) 	_allowance;
16 
17 	event 	Transfer( address from, address to, bytes32 picture );
18 	event 	Approval( address owner, address spender, bytes32 cryptoPicture, bool resolution );
19 
20 	function 	CryptoPicture() public {
21 		_admin = msg.sender;
22 	}
23 
24 	/*** Assert  functions ***/
25 	function 	assertAdmin() view private {
26 		if ( msg.sender != _admin ) {
27 			assert( false );
28 		}
29 	}
30 
31 	function 	assertOwnerPicture( address owner, bytes32 hash ) view private {
32 		if ( owner != _owner[hash] ) {
33 			assert( false );
34 		}
35 	}
36 
37 	function 	assertId( uint id ) view private {
38 		if ( id >= _supply )
39 			assert( false );
40 	}
41 
42 	function 	assertAllowance( address from, bytes32 hash ) view private {
43 		if ( _allowance[from][msg.sender][hash] == false )
44 			assert( false );
45 	}
46 
47 	function 	assertEdit() view private {
48 		if ( _endEdit == true )
49 			assert( false );
50 	}
51 
52 	function	assertProtectedEdit( uint id ) view private {
53 		assertAdmin();
54 		assertEdit();
55 		assertId( id );
56 	}
57 
58 	/*** Admin panel ***/
59 	function  	addPicture( string namePicture, bytes32 hashPicture, string author, address owner ) public {
60 		assertAdmin();
61 		assertId(_id);
62 
63 		setPicture( _id, namePicture, hashPicture, author, owner );
64 		_id++;
65 	}
66 
67 	function	setEndEdit() public {
68 		assertAdmin();
69 		_endEdit = true;
70 	}
71 
72 	function 	setAdmin( address admin ) public {
73 		assertAdmin();
74 		_admin = admin;
75 	}
76 
77 	/*** Edit function for Admin ***/
78 	function 	setNamePiture( uint id, string namePicture ) public {
79 		bytes32 	hash;
80 
81 		assertProtectedEdit( id );
82 
83 		hash = _cryptoPicture[id];
84 		setPicture( id, namePicture, _hashPicture[hash], _author[hash], _owner[hash] );
85 	}
86 
87 	function 	setAuthor( uint id, string author ) public {
88 		bytes32 	hash;
89 
90 		assertProtectedEdit( id );
91 
92 		hash = _cryptoPicture[id];
93 		setPicture( id, _namePicture[hash], _hashPicture[hash], author, _owner[hash]);
94 	}
95 
96 	function 		setHashPiture( uint id, bytes32 hashPicture ) public {
97 		bytes32 	hash;
98 
99 		assertProtectedEdit( id );
100 
101 		hash = _cryptoPicture[id];
102 		setPicture( id, _namePicture[hash], hashPicture, _author[hash], _owner[hash] );
103 	}
104 
105 	function 		setOwner( uint id, address owner ) public {
106 		bytes32 	hash;
107 
108 		assertProtectedEdit( id );
109 
110 		hash = _cryptoPicture[id];
111 		setPicture( id, _namePicture[hash], _hashPicture[hash], _author[hash], owner );
112 	}
113 
114 	/*** private function for edit field cryptoPicture	***/
115 	function 	setPicture( uint id, string namePicture, bytes32 hashPicture, string author, address owner ) private {
116 		bytes32 	hash;
117 
118 		hash = sha256( this, id, namePicture, hashPicture, author );
119 
120 		_cryptoPicture[id] = hash;
121 		_namePicture[hash] = namePicture;
122 		_author[hash] = author;
123 		_owner[hash] = owner;
124 		_hashPicture[hash] = hashPicture;
125 	}
126 
127 	/*** ERC20 similary ***/
128 	function 	totalSupply() public constant returns ( uint )  {
129 		return 	_supply;
130 	}
131 
132 	function 	allowance( address owner, address spender, bytes32 picture) public constant returns ( bool ) {
133 		return 	_allowance[owner][spender][picture];
134 	}
135 
136 	function 	approve( address spender, bytes32 hash, bool resolution ) public returns ( bool ) {
137 		assertOwnerPicture( msg.sender, hash );
138 
139 		_allowance[msg.sender][spender][hash] = resolution;
140 		Approval( msg.sender, spender, hash, resolution );
141 		return true;
142 	}
143 
144 	function 	transfer( address to, bytes32 hash ) public returns ( bool ) {
145 		assertOwnerPicture( msg.sender, hash );
146 
147 		_owner[hash] = to;
148 		Transfer( msg.sender, to, hash );
149 		return true;
150 	}
151 
152 	function 	transferFrom( address from, address to, bytes32 hash ) public returns( bool ) {
153 		assertOwnerPicture( from, hash );
154 		assertAllowance( from, hash );
155 
156 		_owner[hash] = to;
157 		_allowance[from][msg.sender][hash] = false;
158 		Transfer( from, to, hash );
159 		return true;
160 	}
161 
162 	/*** Get variable ***/
163 	function 	getCryptoPicture( uint id ) public constant returns ( bytes32 ) {
164 		assertId( id );
165 
166 		return _cryptoPicture[id];
167 	}
168 
169 	function 	getNamePicture( bytes32 picture ) public constant returns ( string ) {
170 		return _namePicture[picture];
171 	}
172 
173 	function 	getAutorPicture( bytes32 picture ) public constant returns ( string ) {
174 		return _author[picture];
175 	}
176 
177 	function 	getHashPicture( bytes32 picture ) public constant returns ( bytes32 ) {
178 		return _hashPicture[picture];
179 	}
180 
181 	function 	getOwnerPicture( bytes32 picture ) public constant returns ( address ) {
182 		return _owner[picture];
183 	}
184 }
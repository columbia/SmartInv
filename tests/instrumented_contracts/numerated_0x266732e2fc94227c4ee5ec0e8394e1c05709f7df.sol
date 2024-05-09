1 /**
2  * Copyright 2017-2020, bZeroX, LLC <https://bzx.network/>. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5 
6 pragma solidity 0.5.17;
7 
8 
9 contract IERC20 {
10     string public name;
11     uint8 public decimals;
12     string public symbol;
13     function totalSupply() public view returns (uint256);
14     function balanceOf(address _who) public view returns (uint256);
15     function allowance(address _owner, address _spender) public view returns (uint256);
16     function approve(address _spender, uint256 _value) public returns (bool);
17     function transfer(address _to, uint256 _value) public returns (bool);
18     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 /*
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with GSN meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 contract Context {
34     // Empty internal constructor, to prevent people from mistakenly deploying
35     // an instance of this contract, which should be used via inheritance.
36     constructor () internal { }
37     // solhint-disable-previous-line no-empty-blocks
38 
39     function _msgSender() internal view returns (address payable) {
40         return msg.sender;
41     }
42 
43     function _msgData() internal view returns (bytes memory) {
44         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
45         return msg.data;
46     }
47 }
48 
49 /**
50  * @dev Contract module which provides a basic access control mechanism, where
51  * there is an account (an owner) that can be granted exclusive access to
52  * specific functions.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64      * @dev Initializes the contract setting the deployer as the initial owner.
65      */
66     constructor () internal {
67         address msgSender = _msgSender();
68         _owner = msgSender;
69         emit OwnershipTransferred(address(0), msgSender);
70     }
71 
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     /**
80      * @dev Throws if called by any account other than the owner.
81      */
82     modifier onlyOwner() {
83         require(isOwner(), "unauthorized");
84         _;
85     }
86 
87     /**
88      * @dev Returns true if the caller is the current owner.
89      */
90     function isOwner() public view returns (bool) {
91         return _msgSender() == _owner;
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public onlyOwner {
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      */
105     function _transferOwnership(address newOwner) internal {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         emit OwnershipTransferred(_owner, newOwner);
108         _owner = newOwner;
109     }
110 }
111 
112 contract BZRXv1Converter is Ownable {
113 
114     event ConvertBZRX(
115         address indexed sender,
116         uint256 amount
117     );
118 
119     IERC20 public constant BZRXv1 = IERC20(0x1c74cFF0376FB4031Cd7492cD6dB2D66c3f2c6B9);
120     IERC20 public constant BZRX = IERC20(0x56d811088235F11C8920698a204A5010a788f4b3);
121 
122     uint256 public totalConverted;
123     uint256 public terminationTimestamp;
124 
125     function convert(
126         uint256 _tokenAmount)
127         external
128     {
129         require((
130             _getTimestamp() < terminationTimestamp &&
131             msg.sender != address(1)) ||
132             msg.sender == owner(), "convert not allowed");
133 
134         BZRXv1.transferFrom(
135             msg.sender,
136             address(1), // burn address, since transfers to address(0) are not allowed by the token
137             _tokenAmount
138         );
139 
140         BZRX.transfer(
141             msg.sender,
142             _tokenAmount
143         );
144 
145         // overflow condition cannot be reached since the above will throw for bad amounts
146         totalConverted += _tokenAmount;
147 
148         emit ConvertBZRX(
149             msg.sender,
150             _tokenAmount
151         );
152     }
153 
154     // open convert tool to the public
155     function initialize()
156         external
157         onlyOwner
158     {
159         require(terminationTimestamp == 0, "already initialized");
160         terminationTimestamp = _getTimestamp() + 60 * 60 * 24 * 365; // one year from now
161     }
162 
163     // funds unclaimed after one year can be rescued
164     function rescue(
165         address _receiver,
166         uint256 _amount)
167         external
168         onlyOwner
169     {
170         require(_getTimestamp() > terminationTimestamp, "unauthorized");
171 
172         BZRX.transfer(
173             _receiver,
174             _amount
175         );
176     }
177 
178     function _getTimestamp()
179         internal
180         view
181         returns (uint256)
182     {
183         return block.timestamp;
184     }
185 }
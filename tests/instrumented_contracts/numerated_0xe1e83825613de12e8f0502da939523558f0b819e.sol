1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.5;
3 
4 interface IOwnable {
5   function policy() external view returns (address);
6 
7   function renounceManagement() external;
8   
9   function pushManagement( address newOwner_ ) external;
10   
11   function pullManagement() external;
12 }
13 
14 contract Ownable is IOwnable {
15 
16     address internal _owner;
17     address internal _newOwner;
18 
19     event OwnershipPushed(address indexed previousOwner, address indexed newOwner);
20     event OwnershipPulled(address indexed previousOwner, address indexed newOwner);
21 
22     constructor () {
23         _owner = msg.sender;
24         emit OwnershipPushed( address(0), _owner );
25     }
26 
27     function policy() public view override returns (address) {
28         return _owner;
29     }
30 
31     modifier onlyPolicy() {
32         require( _owner == msg.sender, "Ownable: caller is not the owner" );
33         _;
34     }
35 
36     function renounceManagement() public virtual override onlyPolicy() {
37         emit OwnershipPushed( _owner, address(0) );
38         _owner = address(0);
39     }
40 
41     function pushManagement( address newOwner_ ) public virtual override onlyPolicy() {
42         require( newOwner_ != address(0), "Ownable: new owner is the zero address");
43         emit OwnershipPushed( _owner, newOwner_ );
44         _newOwner = newOwner_;
45     }
46     
47     function pullManagement() public virtual override {
48         require( msg.sender == _newOwner, "Ownable: must be new owner to pull");
49         emit OwnershipPulled( _owner, _newOwner );
50         _owner = _newOwner;
51     }
52 }
53 
54 interface IBond {
55     function redeem( address _recipient, bool _stake ) external returns ( uint );
56     function pendingPayoutFor( address _depositor ) external view returns ( uint pendingPayout_ );
57 }
58 
59 contract RedeemHelper is Ownable {
60 
61     address[] public bonds;
62 
63     function redeemAll( address _recipient, bool _stake ) external {
64         for( uint i = 0; i < bonds.length; i++ ) {
65             if ( bonds[i] != address(0) ) {
66                 if ( IBond( bonds[i] ).pendingPayoutFor( _recipient ) > 0 ) {
67                     IBond( bonds[i] ).redeem( _recipient, _stake );
68                 }
69             }
70         }
71     }
72 
73     function addBondContract( address _bond ) external onlyPolicy() {
74         require( _bond != address(0) );
75         bonds.push( _bond );
76     }
77 
78     function removeBondContract( uint _index ) external onlyPolicy() {
79         bonds[ _index ] = address(0);
80     }
81 }
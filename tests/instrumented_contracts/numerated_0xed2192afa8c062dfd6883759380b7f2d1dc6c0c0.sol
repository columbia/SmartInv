1 pragma solidity ^0.4.16;
2 
3 /// @author Bowen Sanders
4 /// sections built on the work of Jordi Baylina (Owned, data structure)
5 /// smartwedindex.sol contains a simple index of contract address, couple name, actual marriage date, bool displayValues to
6 /// be used to create an array of all SmartWed contracts that are deployed 
7 /// contract 0wned is licesned under GNU-3
8 
9 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
10 ///  later changed
11 contract Owned {
12 
13     /// @dev `owner` is the only address that can call a function with this
14     /// modifier
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     address public owner;
21 
22     /// @notice The Constructor assigns the message sender to be `owner`
23     function Owned() {
24         owner = msg.sender;
25     }
26 
27     address public newOwner;
28 
29     /// @notice `owner` can step down and assign some other address to this role
30     /// @param _newOwner The address of the new owner
31     ///  an unowned neutral vault, however that cannot be undone
32     function changeOwner(address _newOwner) onlyOwner {
33         newOwner = _newOwner;
34     }
35     /// @notice `newOwner` has to accept the ownership before it is transferred
36     ///  Any account or any contract with the ability to call `acceptOwnership`
37     ///  can be used to accept ownership of this contract, including a contract
38     ///  with no other functions
39     function acceptOwnership() {
40         if (msg.sender == newOwner) {
41             owner = newOwner;
42         }
43     }
44 
45     // This is a general safty function that allows the owner to do a lot
46     //  of things in the unlikely event that something goes wrong
47     // _dst is the contract being called making this like a 1/1 multisig
48     function execute(address _dst, uint _value, bytes _data) onlyOwner {
49         _dst.call.value(_value)(_data);
50     }
51 }
52 
53 // contract WedIndex 
54 
55 contract WedIndex is Owned {
56 
57     // declare index data variables
58     string public wedaddress;
59     string public partnernames;
60     uint public indexdate;
61     uint public weddingdate;
62     uint public displaymultisig;
63 
64     IndexArray[] public indexarray;
65 
66     struct IndexArray {
67         uint indexdate;
68         string wedaddress;
69         string partnernames;
70         uint weddingdate;
71         uint displaymultisig;
72     }
73 
74     // make functions to write and read index entries and nubmer of entries
75     function writeIndex(uint indexdate, string wedaddress, string partnernames, uint weddingdate, uint displaymultisig) {
76         indexarray.push(IndexArray(now, wedaddress, partnernames, weddingdate, displaymultisig));
77         IndexWritten(now, wedaddress, partnernames, weddingdate, displaymultisig);
78     }
79 
80     // declare events
81     event IndexWritten (uint time, string contractaddress, string partners, uint weddingdate, uint display);
82 }
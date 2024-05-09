1 pragma solidity ^0.4.13;
2 
3 contract Owned {
4     function Owned() {
5         owner = msg.sender;
6     }
7 
8     address public owner;
9 
10     // This contract only defines a modifier and a few useful functions
11     // The function body is inserted where the special symbol "_" in the
12     // definition of a modifier appears.
13     modifier onlyOwner { if (msg.sender == owner) _; }
14 
15     function changeOwner(address _newOwner) onlyOwner {
16         owner = _newOwner;
17     }
18 
19     // This is a general safty function that allows the owner to do a lot
20     //  of things in the unlikely event that something goes wrong
21     // _dst is the contract being called making this like a 1/1 multisig
22     function execute(address _dst, uint _value, bytes _data) onlyOwner {
23         _dst.call.value(_value)(_data);
24     }
25 }
26 
27 contract ChooseWHGReturnAddress is Owned {
28 
29     mapping (address => address) returnAddresses;
30     uint public endDate;
31 
32     /// @param _endDate After this time, if `requestReturn()` has not been called
33     /// the upgraded parity multisig will be locked in as the 'returnAddr'
34     function ChooseWHGReturnAddress(uint _endDate) {
35         endDate = _endDate;
36     }
37 
38     /////////////////////////
39     //   IMPORTANT
40     /////////////////////////
41     // @dev The `returnAddr` can be changed only once.
42     //  We will send the funds to the chosen address. This is Crypto, if the
43     //  address is wrong, your funds could be lost, please, proceed with extreme
44     //  caution and treat this like you are sending all of your funds to this
45     //  address.
46 
47     /// @notice This function is used to choose an address for returning the funds.
48     ///  This function can only be called once, PLEASE READ THE NOTE ABOVE.
49     /// @param _returnAddr The address that will receive the recued funds
50     function requestReturn(address _returnAddr) {
51 
52         // After the end date, the newly deployed parity multisig will be
53         //  chosen if no transaction is made.
54         require(now <= endDate);
55 
56         require(returnAddresses[msg.sender] == 0x0);
57         returnAddresses[msg.sender] = _returnAddr;
58         ReturnRequested(msg.sender, _returnAddr);
59     }
60     /// @notice This is a simple getter function that will be used to return the
61     ///  address that the WHG will return the funds to
62     /// @param _addr The address of the newly deployed parity multisig
63     /// @return address The chosen address that the funds will be returned to
64     function getReturnAddress(address _addr) constant returns (address) {
65         if (returnAddresses[_addr] == 0x0) {
66             return _addr;
67         } else {
68             return returnAddresses[_addr];
69         }
70     }
71 
72     function isReturnRequested(address _addr) constant returns (bool) {
73         return returnAddresses[_addr] != 0x0;
74     }
75 
76     event ReturnRequested(address indexed origin, address indexed returnAddress);
77 }
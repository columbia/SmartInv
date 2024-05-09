1 pragma solidity 0.5.4;
2 
3 contract Ownable {
4     address private _owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     /**
9      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10      * account.
11      */
12     constructor () internal {
13         _owner = msg.sender;
14         emit OwnershipTransferred(address(0), _owner);
15     }
16 
17     /**
18      * @return the address of the owner.
19      */
20     function owner() public view returns (address) {
21         return _owner;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(isOwner());
29         _;
30     }
31 
32     /**
33      * @return true if `msg.sender` is the owner of the contract.
34      */
35     function isOwner() public view returns (bool) {
36         return msg.sender == _owner;
37     }
38 
39     /**
40      * @dev Allows the current owner to relinquish control of the contract.
41      * It will not be possible to call the functions with the `onlyOwner`
42      * modifier anymore.
43      * @notice Renouncing ownership will leave the contract without an owner,
44      * thereby removing any functionality that is only available to the owner.
45      */
46     function renounceOwnership() public onlyOwner {
47         emit OwnershipTransferred(_owner, address(0));
48         _owner = address(0);
49     }
50 
51     /**
52      * @dev Allows the current owner to transfer control of the contract to a newOwner.
53      * @param newOwner The address to transfer ownership to.
54      */
55     function transferOwnership(address newOwner) public onlyOwner {
56         _transferOwnership(newOwner);
57     }
58 
59     /**
60      * @dev Transfers control of the contract to a newOwner.
61      * @param newOwner The address to transfer ownership to.
62      */
63     function _transferOwnership(address newOwner) internal {
64         require(newOwner != address(0));
65         emit OwnershipTransferred(_owner, newOwner);
66         _owner = newOwner;
67     }
68 }
69 
70 contract EthOwl is Ownable {
71   uint256 public price = 2e16;
72 
73   event Hoot(address addr, string endpoint);
74 
75   function adjustPrice(uint256 _price) public onlyOwner {
76     price = _price;
77   }
78 
79   function purchase(address _addr, string memory _endpoint) public payable {
80     require(msg.value >= price);
81     emit Hoot(_addr, _endpoint);
82   }
83 
84   function withdraw() public onlyOwner {
85     msg.sender.transfer(address(this).balance);
86   }
87 }
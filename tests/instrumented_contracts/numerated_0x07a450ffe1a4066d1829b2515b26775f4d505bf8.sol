1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Owned contract
5 // ----------------------------------------------------------------------------
6 contract Owned {
7     address public owner;
8     address public newOwner;
9 
10     event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address _newOwner) public onlyOwner {
22         newOwner = _newOwner;
23     }
24     function acceptOwnership() public {
25         require(msg.sender == newOwner);
26         emit OwnershipTransferred(owner, newOwner);
27         owner = newOwner;
28         newOwner = address(0);
29     }
30 }
31 
32 // ----------------------------------------------------------------------------
33 // 解锁记录合约
34 // ----------------------------------------------------------------------------
35 contract IMCUnlockRecord is Owned{
36 
37     // 解锁记录添加日志
38     event UnlockRecordAdd(uint _date, bytes32 _hash, string _data, string _fileFormat, uint _stripLen);
39 
40     // Token解锁统计记录
41     struct RecordInfo {
42         uint date;  // 记录日期（解锁ID）
43         bytes32 hash;  // 文件hash
44         string data; // 统计数据
45         string fileFormat; // 上链存证的文件格式
46         uint stripLen; // 上链存证的文件分区
47     }
48     
49     // 解锁记录
50     mapping(uint => RecordInfo) public unlockRecord;
51     
52     constructor() public{
53 
54     }
55     
56      
57     /**
58      * 解锁记录添加
59      * @param _date uint 记录日期（解锁ID）
60      * @param _hash bytes32 文件hash
61      * @param _data string 统计数据
62      * @param _fileFormat string 上链存证的文件格式
63      * @param _stripLen uint 上链存证的文件分区
64      * @return success 添加成功
65      */
66     function unlockRecordAdd(uint _date, bytes32 _hash, string _data, string _fileFormat, uint _stripLen) public onlyOwner returns (bool) {
67         
68         // 防止重复记录
69         require(!(unlockRecord[_date].date > 0));
70 
71         // 记录解锁信息
72         unlockRecord[_date] = RecordInfo(_date, _hash, _data, _fileFormat, _stripLen);
73 
74         // 解锁日志记录
75         emit UnlockRecordAdd(_date, _hash, _data, _fileFormat, _stripLen);
76         
77         return true;
78         
79     }
80 
81 }
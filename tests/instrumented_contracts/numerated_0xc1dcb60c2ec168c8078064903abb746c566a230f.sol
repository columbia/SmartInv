1 contract generic_holder {
2     address owner;
3     
4     modifier onlyowner {
5         if (owner == msg.sender)
6             _;
7     }
8     
9     // constructor
10     function generic_holder() {
11         owner = msg.sender;
12     }
13     
14     function change_owner(address new_owner) external onlyowner {
15         owner = new_owner;
16     }
17     
18     function execute(address _to, uint _value, bytes _data) external onlyowner returns (bool){
19         return _to.call.value(_value)(_data);
20     }
21     
22     function get_owner() constant returns (address) {
23         return owner;
24     }
25 }
1 contract SimpleStorage {
2     event valueChanged(string oldValue, string newValue);
3 
4     string _value;
5 
6     function setValue(string value) {
7         valueChanged(_value, value);
8         _value = value;
9     }
10 
11     function getValue() constant returns (string) {
12         return _value;
13     }
14 }
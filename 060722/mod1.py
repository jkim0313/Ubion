def func_1(_a, _b):
    return _a + _b

def func_2(_a, _b):
    return _a - _b

def func_3(_a, _b):
    return _a * _b

class Data():
    def __init__(self, _data):
        self.data = _data
        
    def func_4(self):
        return f'Class에서 입력받은 data의 값은 {self.data}입니다.'
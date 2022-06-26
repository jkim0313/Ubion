def func_10(_x, _y):
    sum = 0
    for i in range(_x, _y+1, 1):            # _x부터 _y까지 숫자의 합
        sum += i
    return sum

class Class_10():
    def __init__(self, _a, _b):             # class __init__ 함수에서 매개변수 2개
        self.a = _a
        self.b = _b
        
    def func_11(self):
        return self.a ** self.b             # _a ** _b의 값


    

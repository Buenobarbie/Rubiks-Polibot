# x -> hit once
# y -> hit twice
# z -> hit thrice
# r -> rotate cw 90
# i -> rotate ccw 90
# p -> rotate cw 180
# q -> rotate ccw 180
# 1 -> rotate ccw 90 (blocked)
# 2 -> rotate cw 90 (blocked)
# 3 -> rotate ccw 180 (blocked)
# 4 -> rotate cw 180 (blocked)

moves = [{"R": ["z1x"],"R'": ["yixrxi2x"],"R2":["z3x"],
          "L":["x1z"],"L'":["xi2xixi"],"L2":["x3z"],
          "U":["y1y"],"U'":["yi2yi"],"U2":["y3y"],
          "D":["1"],"D'":["zixrxi2"],"D2":["3"],
          "F":["iz1xr"],"F'":["iz2ixrx"],"F2":["qxrzr3xr","xizi4ixrx"],
          "B":["ix1zr"],"B'":["ix2yixrx"],"B2":["xixi4xi"]},

         {"R": ["z1x"],"R'": ["z2x"],"R2":["rxizi4x","ixrzr3x"],
          "L":["x1z"],"L'":["x2z"],"L2":["ixrxi4z","rxixr3z"],
          "U":["y1y"],"U'":["y2y"],"U2":["xixrxi4y","xrxixr3y"],
          "D":["1"],"D'":["2"],"D2":["xixrzr3","xrxizi4"],
          "F":["rx1zi"],"F'":["iz2xr"],"F2":["rx3yrxix","iz4ixrx"],
          "B":["rz1xi"],"B'":["ix2yixrx"],"B2":["ix4yixrx","rz3rxix"]},

         {"R": ["yrxixr1x"],"R'": ["z2x"],"R2":["z4x"],
          "L":["xr1xrxr"],"L'":["x2z"],"L2":["x4z"],
          "U":["yr1yr"],"U'":["y2y"],"U2":["y4y"],
          "D":["zrxixr1"],"D'":["2"],"D2":["4"],
          "F":["rx1yrxix"],"F'":["rx2zi"],"F2":["xrxr3xr"],
          "B":["rz1rxix"],"B'":["rz2xi"],"B2":["pxizi4xi","xrzr3rxix"]}]

nextState =[{"R": [1],"R'": [0],"R2":[2],
          "L":[1],"L'":[2],"L2":[2],
          "U":[1],"U'":[1],"U2":[2],
          "D":[1],"D'":[0],"D2":[2],
          "F":[1],"F'":[0],"F2":[1,0],
          "B":[1],"B'":[0],"B2":[1]},

         {"R": [2],"R'": [0],"R2":[0,2],
          "L":[2],"L'":[0],"L2":[0,2],
          "U":[2],"U'":[0],"U2":[0,2],
          "D":[2],"D'":[0],"D2":[2,0],
          "F":[2],"F'":[0],"F2":[2,0],
          "B":[2],"B'":[1],"B2":[0,2]},

         {"R": [2],"R'": [1],"R2":[0],
          "L":[0],"L'":[1],"L2":[0],
          "U":[1],"U'":[1],"U2":[0],
          "D":[2],"D'":[1],"D2":[0],
          "F":[2],"F'":[1],"F2":[1],
          "B":[2],"B'":[1],"B2":[1,2]}]

str = "F2 U R2 U'"
sol = str.split()

def cancle(str):
    stack = []
    stack.append("0")
    rot = 0
    for i in str:
        top = stack.pop()
        if(i == "x"):
            if(top == "x"):
                stack.append("y")
                continue
            if(top == "y"):
                stack.append("z")
                continue
            if(top == "z"):
                continue
        if (i == "y"):
            if (top == "x"):
                stack.append("z")
                continue
            if (top == "y"):
                continue
            if (top == "z"):
                stack.append("x")
                continue
        if (i == "z"):
            if (top == "x"):
                continue
            if (top == "y"):
                stack.append("x")
                continue
            if (top == "z"):
                stack.append("y")
                continue
        if (i == "r"):
            if (top == "r"):
                stack.append("p")
                continue
            if (top == "i"):
                continue
            if (top == "q"):
                stack.append("i")
                continue
        if (i == "i"):
            if (top == "r"):
                continue
            if (top == "i"):
                stack.append("q")
                continue
            if (top == "p"):
                stack.append("r")
                continue
        if (i == "p"):
            if (top == "i"):
                stack.append("r")
                continue
            if (top == "q" or top == "p"):
                continue
        if (i == "q"):
            if (top == "r"):
                stack.append("i")
                continue
            if (top == "q" or top == "p"):
                continue
        stack.append(top)
        stack.append(i)
        if(i == "1" or i == "2" or i == "3" or i == "4"):
            rot = rot + 1
            if(rot == len(sol)):
                break;
    return stack

def value(stack):
    value = 0
    for i in stack:
        if(i == "r" or i == "i"):
            value = value + 1
        if(i == "p" or i == "q"):
            value = value + 1.5
        if(i == "x"):
            value = value + 2
        if(i == "y"):
            value = value + 3.5
        if(i == "z"):
            value = value + 4.5
    return value

def reduce(i,str,state):
    if(i == len(sol)):
        str = cancle(str)
        return str
    length = 99999
    best = ""
    for j in range(len(moves[state][sol[i]])):
        temp  = reduce(i+1,str+moves[state][sol[i]][j],nextState[state][sol[i]][j])
        val = value(stack = temp)
        if(val < length):
            length = val
            best = temp
    return best

def nMoves(str):
    n = 0
    for i in str:
        n = n + 1
        if(i == "y"):
            n = n + 1
        if(i == "z"):
            n = n + 2
    return n
strReduced = reduce(i = 0,str = "",state = 0)
strReduced = strReduced[1:]
print("".join(strReduced))

# 1: hit
# 2: block
# 3: unblock
# 4: rotate to 0°
# 5: rotate to 90°
# 6: rotate to 180°

def process_signals(signals):
    # Define mappings
    hits = {'x': '1', 'y': '11', 'z': '111'}
    rotations = {
        'r': -90, 'i': 90, 'p': -180, 'q': 180,
        '1': 90, '2': -90, '3': 180, '4': -180
    }
    blocked_rotations = {'1', '2', '3', '4'}
    target_angles = {
    0: '4',    # Rotate to 0°
    90: '5',   # Rotate to 90°
    180: '6',  # Rotate to 180°
    270: '5'   # Rotate to 90° (270° is equivalent to -90°)
}

    
    # Track current position
    current_angle = 0
    result = []
    
    for signal in signals:
        if signal in hits:
            # Add hits to result
            result.append(hits[signal])
        elif signal in rotations:
            # Calculate target angle
            rotation = rotations[signal]
            if signal in blocked_rotations:
                # Blocked rotation
                result.append('2')  # Block
                rotation_command = target_angles[(current_angle + rotation) % 360]
                current_angle = (current_angle + rotation) % 360
                result.append(rotation_command)  # Rotate
                result.append('3')  # Unblock
            else:
                # Unblocked rotation
                current_angle = (current_angle + rotation) % 360
                rotation_command = target_angles[current_angle]
                result.append(rotation_command)
    
    return ''.join(result)

# Example usage
signals = strReduced
print(process_signals(signals))



    



import re
import os

VARIANT = 7

B = BooleanPolynomialRing(64, 'x', 'degrevlex')
B.inject_variables()

with open(f'Variants_FilterFunction/V{VARIANT}.txt', 'r') as file:
    f = file.read()

f = re.sub(r'([\_\{\}])', '', f)
f = re.sub(r'(?<=\d)[\s](?=x\d)', ' * ', f)

f = eval(f)
f_1 = f + 1

I, I_1 = Ideal(f), Ideal(f_1)

print('Ideal done!')

if 'GB.txt' and 'GB_1.txt' not in os.listdir():
    GB, GB_1 = I.groebner_basis(), I_1.groebner_basis()
    with open('GB.txt', 'w') as file:
        [file.write(f'{i}\n') for i in GB]

    with open('GB_1.txt', 'w') as file:
        [file.write(f'{i}\n') for i in GB_1]
else:
    with open('GB.txt', 'r') as file:
        GB = file.readlines()
    with open('GB_1.txt', 'r') as file:
        GB_1 = file.readlines()

h = eval(GB[-1].replace('\n', '')) if isinstance(GB[-1], str) else GB[-1]
h_1 = eval(GB_1[-1].replace('\n', '')) if isinstance(GB_1[-1], str) else GB_1[-1]

with open('polynome.txt', 'r') as file:
    polynome = file.read()

p = B['x'](polynome)

C = companion_matrix(p, format='bottom')

state = vector(B, (eval(f'x{i}') for i in range(64)))

with open(f'Variants_Gamma/V{VARIANT}.txt', 'r') as file:
    gamma = file.read()

equations = []

print('Equations start')

for i in range(4000):
    state = C * state
    if gamma[i] == '0':
        equations.append(h(*(state)))
    else:
        equations.append(h_1(*(state)))

I_eq = Ideal(equations)

print('Ideal equations done!')

GB_eq = I_eq.groebner_basis()
with open('GB_result.txt', 'w') as file:
    [file.write(f'{i}\n') for i in GB_eq]
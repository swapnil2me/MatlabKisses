clear all;
clc;
syms r theta z
x = r*cos(theta);
y = r*sin(theta);
jaco = [diff([x y z],r);diff([x y z],theta);diff([x y z],z)];
djaco = det(jaco);
fact = simplify(djaco)
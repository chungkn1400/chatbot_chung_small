#Include Once "windows.bi"
#Include Once "GL/gl.bi"
#include Once "GL/glu.bi"

Static Shared As glfloat glparamfloat4(4) 
Static Shared As glint glparamint4(4) 
Function glparam4f(ByVal x As Single,ByVal y As Single,ByVal z As Single,ByVal t As Single) As glfloat Ptr 
	glparamfloat4(0)=x
	glparamfloat4(1)=y
	glparamfloat4(2)=z
	glparamfloat4(3)=t
Return @glparamfloat4(0)	
End Function
Function glparam4i(ByVal x As integer,ByVal y As integer,ByVal z As integer,ByVal t As Integer) As glint Ptr 
	glparamint4(0)=x
	glparamint4(1)=y
	glparamint4(2)=z
	glparamint4(3)=t
Return @glparamint4(0)	
End Function
sub glsphere(ByVal rayon As Double,ByVal nx As uint=20,ByVal ny As uint=20)
   Dim As gluquadric Ptr hquad
   hquad=gluNewQuadric()
   gluSphere hquad,rayon,nx,ny
   gluDeleteQuadric hquad
end sub
Sub gltexsphere(ByVal rayon As Double,ByVal nx As uint=20,ByVal ny As uint=20)
   Dim As gluquadric Ptr hquad
   hquad=gluNewQuadric()
   gluQuadricTexture hquad,GL_TRUE
   gluSphere hquad,rayon,nx,ny
   gluDeleteQuadric hquad
End Sub
Sub glcylindre(ByVal rbase As Double,ByVal rtop As Double,ByVal haut As Double,_ 
	            ByVal nx As uint=20,ByVal ny As uint=20)
   Dim As gluquadric Ptr hquad
   hquad=gluNewQuadric()
   glucylinder hquad,rbase,rtop,haut,nx,ny
   gluDeleteQuadric hquad
end sub
Sub gltexcylindre(ByVal rbase As Double,ByVal rtop As Double,ByVal haut As Double,_ 
	            ByVal nx As uint=20,ByVal ny As uint=20)
   Dim As gluquadric Ptr hquad
   hquad=gluNewQuadric()
   gluQuadricTexture hquad,GL_TRUE
   glucylinder hquad,rbase,rtop,haut,nx,ny
   gluDeleteQuadric hquad
end sub
Sub gldisk(ByVal rint As Double,ByVal rext As Double,ByVal nx As uint=20,ByVal ny As uint=20)
   Dim As gluquadric Ptr hquad
   hquad=gluNewQuadric()
   glnormal3d 0,0,1
   gludisk hquad,rint,rext,nx,ny
   gluDeleteQuadric hquad
end sub
Sub gltexdisk(ByVal rint As Double,ByVal rext As Double,ByVal nx As uint=20,ByVal ny As uint=20)
   Dim As gluquadric Ptr hquad
   hquad=gluNewQuadric()
   glnormal3d 0,0,1
   gluQuadricTexture hquad,GL_TRUE
   gludisk hquad,rint,rext,nx,ny
   gluDeleteQuadric hquad
end sub
Sub gldiskangle(ByVal rint As Double,ByVal rext As Double,_ 
	             ByVal angle1 As Double,ByVal angle2 As Double,_ 
	             ByVal nx As uint=20,ByVal ny As uint=20) 
   Dim As gluquadric Ptr hquad
   hquad=gluNewQuadric()
   glnormal3d 0,0,1
   glupartialdisk hquad,rint,rext,nx,ny,angle1,angle2
   gluDeleteQuadric hquad
end sub
sub gltexdiskangle(ByVal rint As Double,ByVal rext As Double,_ 
	             ByVal angle1 As Double,ByVal angle2 As Double,_ 
	             ByVal nx As uint=20,ByVal ny As uint=20) 
   Dim As gluquadric Ptr hquad
   hquad=gluNewQuadric()
   glnormal3d 0,0,1
   gluQuadricTexture hquad,GL_TRUE
   glupartialdisk hquad,rint,rext,nx,ny,angle1,angle2
   gluDeleteQuadric hquad
end sub
Sub glcarre(ByVal dx As Single)
	glbegin(gl_quads)
	glvertex3f(-dx,-dx,0)
	glvertex3f(dx,-dx,0)
	glvertex3f(dx,dx,0)
	glvertex3f(-dx,dx,0)
	glend()
End Sub
Sub glcarre3(ByVal dx As Single)
	glbegin(gl_quads)
	glvertex3f(0,-dx,-dx)
	glvertex3f(0,dx,-dx)
	glvertex3f(0,dx,dx)
	glvertex3f(0,-dx,dx)
	glend()
End Sub
Sub gltexcarre(ByVal dx As Single,ByVal tx As Single=1)
	glbegin(gl_quads)
	glTexCoord2f(0,0)
	glvertex3f(-dx,-dx,0)
	gltexcoord2f(tx,0)
	glvertex3f(dx,-dx,0)
	glTexCoord2f(tx,tx)
	glvertex3f(dx,dx,0)
	gltexcoord2f(0,tx)
	glvertex3f(-dx,dx,0)
	glend()
End Sub 
sub gltexcarre2(byval x As Single,ByVal y As Single,ByVal tx As Single=1)
Dim As Single x1,x0
x1=x*0.5:x0=0-x1
	glbegin(gl_quads)
	glTexCoord2f(0,0)
	glvertex3f(0,x0,0)
	gltexcoord2f(tx,0)
	glvertex3f(0,x1,0)
	glTexCoord2f(tx,tx)
	glvertex3f(0,x1,y)
	gltexcoord2f(0,tx)
	glvertex3f(0,x0,y)
	glend()
End Sub
sub gltexcarre2rot(byval x As Single,ByVal y As Single,ByVal o1 As Single,ByVal tx As Single=1)
Dim As Single x1,x0,y1,y0,co1,si1
co1=Cos(o1*3.1416/180):si1=Sin(o1*3.1416/180)
x1=x*0.5*co1:x0=-x1
y1=x*0.5*si1:y0=-y1
	glbegin(gl_quads)
	glTexCoord2f(0,0)
	glvertex3f(y0,x0,0)
	gltexcoord2f(tx,0)
	glvertex3f(y1,x1,0)
	glTexCoord2f(tx,tx)
	glvertex3f(y1,x1,y)
	gltexcoord2f(0,tx)
	glvertex3f(y0,x0,y)
	glend()
End Sub
sub gltexcarre3(byval x As Single,ByVal y As Single,ByVal tx As Single=1)
Dim As Single x1,x0,y1,y0
x1=x*0.5:x0=-x1
y1=y*0.5:y0=-y1
	glbegin(gl_quads)
	glTexCoord2f(0,0)
	glvertex3f(0,x0,y0)
	gltexcoord2f(tx,0)
	glvertex3f(0,x1,y0)
	glTexCoord2f(tx,tx)
	glvertex3f(0,x1,y1)
	gltexcoord2f(0,tx)
	glvertex3f(0,x0,y1)
	glend()
End Sub
sub gltexcarre4(byval x As Single,ByVal y As Single,ByVal tx As Single=1)
Dim As Single x1,x0,y1,y0
x1=x*0.5:x0=-x1
y1=y*0.5:y0=-y1
	glbegin(gl_quads)
	glTexCoord2f(0,0)
	glvertex3f(x0,y0,0)
	gltexcoord2f(tx,0)
	glvertex3f(x1,y0,0)
	glTexCoord2f(tx,tx*0.995)
	glvertex3f(x1,y1,0)
	gltexcoord2f(0,tx*0.995)
	glvertex3f(x0,y1,0)
	glend()
End Sub
sub gltexcarre5(byval x As Single,ByVal y As Single,ByVal tx As Single=1)
Dim As Single x1,x0,y1,y0
x1=x*0.5:x0=-x1
y1=y*0.5:y0=-y1
	glbegin(gl_quads)
	glTexCoord2f(tx,0)
	glvertex3f(x0,y0,0)
	gltexcoord2f(tx,tx)
	glvertex3f(x1,y0,0)
	glTexCoord2f(0,tx)
	glvertex3f(x1,y1,0)
	gltexcoord2f(0,0)
	glvertex3f(x0,y1,0)
	glend()
End Sub
Sub gltexquad (ByVal x1 As Single,ByVal y1 As Single,ByVal z1 As Single,_ 
             ByVal x2 As Single,ByVal y2 As Single,ByVal z2 As Single,_
             ByVal x3 As Single,ByVal y3 As Single,ByVal z3 As Single,_
             ByVal x4 As Single,ByVal y4 As Single,ByVal z4 As Single,_ 
             ByVal tx As Single=1,ByVal ty As Single=1)
glBegin GL_QUADS
glTexCoord2f 0,0
glVertex3f x1,y1,z1
glTexCoord2f tx,0
glVertex3f x2,y2,z2
glTexCoord2f tx,ty
glVertex3f x3,y3,z3
glTexCoord2f 0,ty
glVertex3f x4,y4,z4
glEnd
End Sub
sub gltriangle (ByVal x1 As Single,ByVal y1 As Single,ByVal z1 As Single,_ 
                ByVal x2 As Single,ByVal y2 As Single,ByVal z2 As Single,_
                ByVal x3 As Single,ByVal y3 As Single,ByVal z3 As Single )
glBegin GL_triangles
glVertex3f x1,y1,z1
glVertex3f x2,y2,z2
glVertex3f x3,y3,z3
glend
End Sub
sub gltextriangle (ByVal x1 As Single,ByVal y1 As Single,ByVal z1 As Single,_ 
                ByVal x2 As Single,ByVal y2 As Single,ByVal z2 As Single,_
                ByVal x3 As Single,ByVal y3 As Single,ByVal z3 As Single )
glBegin GL_triangles
glTexCoord2f 0,0
glVertex3f x1,y1,z1
glTexCoord2f 2,4
glVertex3f x2,y2,z2
glTexCoord2f 4,0
glVertex3f x3,y3,z3
glend
End Sub
sub glligne  (ByVal x1 As Single,ByVal y1 As Single,ByVal z1 As Single,_ 
             ByVal x2 As Single,ByVal y2 As Single,ByVal z2 As Single)
glBegin GL_LINES
glVertex3f x1,y1,z1
glvertex3f x2,y2,z2
glEnd
End sub


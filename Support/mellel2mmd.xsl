<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exslt="http://exslt.org/common">
<xsl:output method="text"/>
<!-- <xsl:strip-space elements="*"/> -->

	<!--
	
		Mellel2MMD 
		==========
		
		2009/01/22 v.0.37 	

		Copyright (c) 2009, Malte Rosenau
	
		Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

		Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
		Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
		Neither the name of the author nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

	-->


<xsl:variable name="docinfovar" select="/archive/root/document-info/comments"/>

<xsl:variable name="docinfotitle" select="/archive/root/document-info/variables/variable[1]"/>

<xsl:variable name="docinfoauthor" select="/archive/root/document-info/variables/variable[3]"/>

<xsl:variable name="docinfokeywords" select="/archive/root/document-info/keywords"/>

<xsl:variable name="docinfocategory" select="/archive/root/document-info/category"/>

<xsl:variable name="docinfocomments" select="/archive/root/document-info/comments"/>

<xsl:template match="/">
<!-- Use Mellel's Document Info... if available -->

	<xsl:if test="not(contains($docinfotitle, '&gt;'))">	
		<xsl:text>Title: </xsl:text>			
		<xsl:value-of select="$docinfotitle"/>		
		<xsl:text>&#10;</xsl:text>
	</xsl:if>
	<xsl:if test="not(contains($docinfoauthor, '&gt;'))">
		<xsl:text>Author: </xsl:text>	
		<xsl:value-of select="$docinfoauthor"/>		
		<xsl:text>&#10;</xsl:text>
	</xsl:if>
	<xsl:if test="not(contains($docinfokeywords, '&gt;'))">
		<xsl:text>Keywords: </xsl:text>
		<xsl:value-of select="$docinfokeywords"/>		
		<xsl:text>&#10;</xsl:text>
	</xsl:if>
	<xsl:if test="not(contains($docinfocategory, '&gt;'))">
		<xsl:text>Category: </xsl:text>
		<xsl:value-of select="$docinfocategory"/>		
		<xsl:text>&#10;</xsl:text>
	</xsl:if>
    <xsl:if test="not(contains($docinfocomments, '&gt;'))">
    	<xsl:text>Comments: </xsl:text>			
    	<xsl:value-of select="$docinfocomments"/>		
		<xsl:text>&#10;</xsl:text>
	</xsl:if>
	<xsl:for-each select="/archive/root/document-info/variables/variable[position() >3]">  
		<xsl:if test="not(contains(., '&lt;') and contains(., '&gt;'))">
			<xsl:value-of select="."/>
			<xsl:text>&#10;</xsl:text>
   		</xsl:if>
	</xsl:for-each>
	
	<xsl:text>&#10;</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>&#10;&#10;</xsl:text>
	<xsl:for-each select="//note-stream">  
			<!-- Build the numbered notes at the end of the document -->
			<xsl:variable name="Stream" select="./@ref"/>
			<xsl:if test="//note[@stream = $Stream]">
				&#10;
				<xsl:for-each select="//note[@stream = $Stream]">
					<xsl:apply-templates/>
				</xsl:for-each>
			</xsl:if>
	</xsl:for-each>
	<!-- Build the list of image references at the end of the document -->	
	<xsl:for-each select="//image-ref">
		<xsl:text>[</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>]: </xsl:text>
		<xsl:apply-templates/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="../extension-hint"/>		
		<xsl:if test="../../../../following-sibling::p[1]/c/autotitle[@index='3']">
			<xsl:text> "</xsl:text>
			<xsl:value-of select="../../../../following-sibling::p[1]/c/autotitle[@index='3']/c"/>
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text> width=</xsl:text>
		<xsl:value-of select="round(../../frame-width/@value)"/>
		<xsl:text>px height=</xsl:text>
		<xsl:value-of select="round(../../frame-height/@value)"/>
		<xsl:text>px&#10;&#10;</xsl:text>
	</xsl:for-each>
</xsl:template>

<!-- Bibliography -->

<xsl:template match="temp-citation">
	<xsl:text>[</xsl:text>
	<xsl:value-of select="../final-citation"/>
	<xsl:text>][#</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="final-citation">
</xsl:template>

<xsl:template match="image-ref">
	<xsl:text>![</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>][]</xsl:text>
</xsl:template>

<xsl:template match="extension-hint"></xsl:template>

<!-- Paragraphs, lists and notes -->
 
 <xsl:template match="p">
<xsl:variable name="pstyle" select="@style" />
<xsl:variable name="nextstyle" select="following-sibling::p[1]/@style" />

	<xsl:choose>
		<xsl:when test="./@list-level">
			<xsl:variable name="teststyle" select="../@style" />
				<xsl:choose>
					<xsl:when test="(/archive/pooled-objects/list-style[@ref=$teststyle]/levels/level-attributes/symbol-type/@value='arabic') or (/archive/pooled-objects/list-style[@ref=$teststyle]/levels/level-attributes/symbol-type/@value='arabic-indic') or (/archive/pooled-objects/list-style[@ref=$teststyle]/levels/level-attributes/symbol-type/@value='roman-caps') or (/archive/pooled-objects/list-style[@ref=$teststyle]/levels/level-attributes/symbol-type/@value='roman-small') or (/archive/pooled-objects/list-style[@ref=$teststyle]/levels/level-attributes/symbol-type/@value='hebrew') or (/archive/pooled-objects/list-style[@ref=$teststyle]/levels/level-attributes/symbol-type/@value='latin-caps') or (/archive/pooled-objects/list-style[@ref=$teststyle]/levels/level-attributes/symbol-type/@value='lain-small') or (/archive/pooled-objects/list-style[@ref=$teststyle]/levels/level-attributes/symbol-type/@value='persian') or (/archive/pooled-objects/list-style[@ref=$teststyle]/levels/level-attributes/symbol-type/@value='greek') or (/archive/pooled-objects/list-style[@ref=$teststyle]/levels/level-attributes/symbol-type/@value='greek-academy')">
						<xsl:call-template name="printtab">
      						<xsl:with-param name="count" select="@list-level -1"/>
			    		</xsl:call-template>
						<xsl:text>1. </xsl:text>
						<xsl:apply-templates/>
						<xsl:text>&#10;&#10;</xsl:text>
					</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="printtab">
      					<xsl:with-param name="count" select="@list-level -1"/>
    				</xsl:call-template>
					<xsl:text>* </xsl:text>					
					<xsl:apply-templates/>
					<xsl:text>&#10;&#10;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="name(..) = 'note'"> <!-- Deal with notes -->
			<xsl:if test="position() = 1">   <!-- Generate the note number which is at the start of the note para. -->
				<xsl:variable name="noteStream" select="../@stream"/>
				<xsl:variable name="noteNumber" select="count(preceding::note[@stream = $noteStream]) + 1"/>
				<xsl:text>[^</xsl:text>
				<xsl:value-of select="$noteStream"/>
				<xsl:text>-</xsl:text>
				<xsl:value-of select="$noteNumber"/>
				<xsl:text>]</xsl:text>
				<xsl:text>: </xsl:text>	
			</xsl:if>
			<!-- Footnote has multiple paragraphs -->
			<!-- TODO: Lists -->
			<xsl:if test="position()!= 1">
				<xsl:text>&#9;</xsl:text>
			</xsl:if>
			<xsl:apply-templates/>
			<xsl:text>&#10;&#10;</xsl:text>
		</xsl:when>
		 <xsl:when test="/archive/pooled-objects/paragraph-style[@ref=$pstyle]/name='Blockquote'">
		<xsl:text>> </xsl:text>	
		<xsl:apply-templates/>
		<xsl:text>&#10;&#10;</xsl:text>
		</xsl:when>
		<xsl:when test="/archive/pooled-objects/paragraph-style[@ref=$pstyle]/name='Code Block'">
			<xsl:text>    </xsl:text>	
			<xsl:apply-templates/>
			<xsl:text>&#10;</xsl:text>
			<xsl:if test="not(/archive/pooled-objects/paragraph-style[@ref=$nextstyle]/name='Code Block')">
        		<xsl:text>&#10;</xsl:text>

   	    	</xsl:if>	
   	    	
		</xsl:when>
<!-- Do nothing if paragraph is empty -->
 
<!-- 
		<xsl:when test="./c=''">
			<xsl:apply-templates/>	
		</xsl:when>
 -->

		<xsl:otherwise>
			<xsl:apply-templates/>
			<xsl:text>&#10;&#10;</xsl:text>		
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- Notes References in the text (note text lives in the "p" rule) -->	
<xsl:template match="note">
	<xsl:variable name="noteStream" select="./@stream"/>
	<xsl:variable name="noteNum" select="count(preceding::note[@stream = $noteStream]) + 1"/>
	<xsl:text>[^</xsl:text>
	<xsl:value-of select="$noteStream"/>
	<xsl:text>-</xsl:text>
	<xsl:value-of select="$noteNum"/>
	<xsl:text>]</xsl:text>
</xsl:template>


<xsl:template match="list">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template name="printtab">
	<xsl:param name="count" select="1"/>
    	<xsl:if test="$count > 0">
        	<xsl:text>&#9;</xsl:text>
        	<xsl:call-template name="printtab">
          	<xsl:with-param name="count" select="$count - 1"/>
        	</xsl:call-template>
      	</xsl:if>
</xsl:template>


<xsl:template name="printwhitespacethree">
	<xsl:param name="count" select="1"/>
    	<xsl:if test="$count > 0">
        	<xsl:text>   </xsl:text>
        	<xsl:call-template name="printwhitespacethree">
          	<xsl:with-param name="count" select="$count - 1"/>
        	</xsl:call-template>
      	</xsl:if>
</xsl:template>

<xsl:template name="printwhitespacefour">
	<xsl:param name="count" select="1"/>
    	<xsl:if test="$count > 0">
        	<xsl:text>    </xsl:text>
        	<xsl:call-template name="printwhitespacefour">
          	<xsl:with-param name="count" select="$count - 1"/>
        	</xsl:call-template>
      	</xsl:if>
</xsl:template>

<!-- Style Variations and Character Overrides-->

<xsl:template match="c">
<xsl:variable name="cstyle" select="@style" />
	<xsl:choose>
		<xsl:when test="@over">
			<xsl:variable name="testover" select="@over" />
			<xsl:choose>
				<xsl:when test="/archive/pooled-objects/character-overrides[@ref=$testover]/position/@value='superscript'">
					<xsl:text></xsl:text>
					<xsl:apply-templates/>
					<xsl:text></xsl:text>	
				</xsl:when>				
				<xsl:when test="/archive/pooled-objects/character-overrides[@ref=$testover]/position/@value='subscript'">
					<xsl:text></xsl:text>
					<xsl:apply-templates/>
					<xsl:text></xsl:text>	
				</xsl:when>				
				<xsl:when test="(/archive/pooled-objects/character-overrides[@ref=$testover]/main-font/font-family='Monaco') or (/archive/pooled-objects/character-overrides[@ref=$testover]/main-font/font-family='American Typewriter') or (/archive/pooled-objects/character-overrides[@ref=$testover]/main-font/font-family='Courier') or (/archive/pooled-objects/character-overrides[@ref=$testover]/main-font/font-family='Andale Mono')
				or (/archive/pooled-objects/character-overrides[@ref=$testover]/main-font/font-family='Courier New')">
					<xsl:text>`</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>`</xsl:text>	
				</xsl:when>
				<xsl:when test="/archive/pooled-objects/character-overrides[@ref=$testover]/main-font/font-face='Italic'">
					<xsl:text>*</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>*</xsl:text>
				</xsl:when>	
				<xsl:when test="/archive/pooled-objects/character-overrides[@ref=$testover]/main-font/font-face='Bold'">
					<xsl:text>**</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>**</xsl:text>
				</xsl:when>	
				<xsl:when test="/archive/pooled-objects/character-overrides[@ref=$testover]/main-font/font-face='Semibold'">
					<xsl:text>**</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>**</xsl:text>
				</xsl:when>	
				<xsl:when test="/archive/pooled-objects/character-overrides[@ref=$testover]/main-font/font-face='Bold Italic'">
					<xsl:text>***</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>***</xsl:text>
				</xsl:when>	
				<xsl:when test="/archive/pooled-objects/character-overrides[@ref=$testover]/main-font/font-face='Semibold Italic'">
					<xsl:text>***</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>***</xsl:text>
				</xsl:when>	
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="@var='b'">
			<xsl:text>**</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>**</xsl:text>
		</xsl:when>
		<xsl:when test="@var='c'">
			<xsl:text>*</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>*</xsl:text>
		</xsl:when>
		<xsl:when test="@var='d'">
			<xsl:text>***</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>***</xsl:text>
		</xsl:when>
		<xsl:when test="@var='f'">
			<xsl:text>[LINK](</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>)</xsl:text>
		</xsl:when>
		<xsl:when test="@var='g'">
			<xsl:text>[</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>][]</xsl:text>
		</xsl:when>
		<xsl:when test="/archive/pooled-objects/character-style[@ref=$cstyle]/name='Codespan'">
		<xsl:text>`</xsl:text>	
		<xsl:apply-templates/>
		<xsl:text>`</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- Tables-->

<xsl:template match="table">
	<xsl:for-each select="rows/row-group">
		<xsl:text>|</xsl:text> 
			<xsl:for-each select="cells/cell/contents/p">
				<xsl:if test="position()!=last()">
					<xsl:apply-templates/>
					<xsl:text> </xsl:text> 
					<xsl:if test="../../grid-rect/@w &gt; 1">
						<xsl:text>|</xsl:text> 
					</xsl:if>
					<xsl:text>| </xsl:text> 
				</xsl:if>
				<xsl:if test="position()=last()">
					<xsl:apply-templates/>
					<xsl:text> </xsl:text> 
					<xsl:if test="../../grid-rect/@w &gt; 1">
						<xsl:text>|</xsl:text> 
					</xsl:if>
					<xsl:text>|</xsl:text>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="position()=1">
				<xsl:text>&#10;| </xsl:text>
				<xsl:for-each select="cells/cell/contents/p">
					<xsl:if test="position()!=last()">
						<xsl:text>---</xsl:text> 						
						<xsl:text> </xsl:text> 
						<xsl:if test="../../grid-rect/@w &gt; 1">
							<xsl:text>|</xsl:text> 
						</xsl:if>
						<xsl:text>| </xsl:text> 
					</xsl:if>
					<xsl:if test="position()=last()">
						<xsl:text>---</xsl:text> 
						<xsl:text> </xsl:text> 
						<xsl:if test="../../grid-rect/@w &gt; 1">
							<xsl:text>|</xsl:text> 
						</xsl:if>
						<xsl:text>|</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>		
		<xsl:text>&#10;</xsl:text>
	</xsl:for-each>
	<xsl:if test="../../following-sibling::p[1]/c/autotitle[@index='5']">
		<xsl:text>[</xsl:text>	
		<xsl:value-of select="../../following-sibling::p[1]/c/autotitle[@index='5']/c"/>
		<xsl:text>]</xsl:text>
	</xsl:if>
	<xsl:text>&#10;</xsl:text>

</xsl:template>


<!-- Autotitles -->

<xsl:template match="autotitle">
	<xsl:if test="@index=0">
		<xsl:if test="@level=0">
			<xsl:text># </xsl:text>	
			<xsl:apply-templates/>
			<xsl:text> #</xsl:text>
		</xsl:if>
		<xsl:if test="@level=1">		
			<xsl:text>## </xsl:text>	
			<xsl:apply-templates/>
			<xsl:text> ##</xsl:text>	
		</xsl:if>
		<xsl:if test="@level=2">
			<xsl:text>### </xsl:text>	
			<xsl:apply-templates/>
			<xsl:text> ###</xsl:text>	
		</xsl:if>
		<xsl:if test="@level=3">
			<xsl:text>#### </xsl:text>	
			<xsl:apply-templates/>
			<xsl:text> ####</xsl:text>	
		</xsl:if>
		<xsl:if test="@level=4">
			<xsl:text>##### </xsl:text>	
			<xsl:apply-templates/>	
			<xsl:text> ####</xsl:text>
		</xsl:if>
		<xsl:if test="@level=5">
			<xsl:text>###### </xsl:text>	
			<xsl:apply-templates/>	
			<xsl:text> ######</xsl:text>
		</xsl:if>
		<xsl:if test="@level=6">
			<xsl:apply-templates/>	
		</xsl:if>
		<xsl:if test="@level &gt; 6">
			<xsl:apply-templates/>	
		</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="note/note">
<!-- 
ignore Mellel's footnote bug
 -->
</xsl:template>

<xsl:template match="pooled-objects">
</xsl:template>

<xsl:template match="new-selection">
</xsl:template>

<xsl:template match="document-setup">
</xsl:template>

<xsl:template match="outline-settings">
</xsl:template>

<xsl:template match="misc-settings">
</xsl:template>

<xsl:template match="marker-names">
</xsl:template>

<xsl:template match="print-info">
</xsl:template>

<xsl:template match="document-info">
</xsl:template>

<xsl:template match="note-streams">
</xsl:template>

<xsl:template match="auto-title-setup">
</xsl:template>

<xsl:template match="style-set">
</xsl:template>

<xsl:template match="view-options">
</xsl:template>

</xsl:stylesheet>
export class LeduAppHomeData {
  error_code?: number
  error_msg?: string
  status?: string
  msg?: string
  code?: object
  data?: LeduAppHPCourseGroupModel
}

export class LeduAppHPCourseGroupModel {
  courseGroups?: Array<LeduAppCoursePackageGroupModel>
}

export class LeduAppCoursePackageGroupModel {
  groupId?: string
  groupName?: string
  groupDesc?: object
  groupTitle?: string
  groupSubTitle?: object
  groupType?: number
  isExperience?: number
  isSpecialCourse?: number
  styleType?: number
  anchorPointName?: string
  startColor?: object
  endColor?: object
  backgroundImages?: object
  groupBgImg?: string
  groupBgImgColor?: string
  groupMoreBgImg?: string
  courseCards?: Array<LeduAppCoursePackageModel>
  page?: number
  pageSize?: number
  hasMorePage?: number
  morePageRoute?: string
  promotionContent?: object
}

export class LeduAppCoursePackageModel {
  cardId?: string
  cardName?: string
  cardDesc?: string
  cardImage?: string
  cardHeadImg?: string
  courseBgImg?: string
  courseTitle?: string
  courseTitleSplice?: object
  signUpImg?: string
  signUpTitle?: string
  year?: string
  grade?: LeduAppGrade
  term?: LeduAppTerm
  seasonId?: number
  subject?: LeduAppSubject
  star?: string
  earliestClassTime?: string
  classModeId?: number
  classModeName?: string
  classModelLevelId?: object
  classModelLevelName?: object
  classModelId?: object
  curriculumId?: string
  curriculumName?: string
  tag?: object
  tagsCount?: number
  teachers?: Array<LeduAppTeachers>
  priceRange?: string
  origPrice?: object
  strategyInfo?: LeduAppStrategyInfo
  ifSuperviseHited?: boolean
  jumpType?: string
  jumpUrl?: object
  maxClassCount?: number
  cardRegCopy?: object
  labelCourseContent?: object
  haveDjgClass?: object
  cardCoverImg?: string
  extParameters?: LeduAppExtParameters
}

export class LeduAppExtParameters {
  short?: string
  testKey?: string
}

export class LeduAppStrategyInfo {
  requestId?: string
  page?: number
  location?: number
  isChooseCond?: number
}

export class LeduAppTeachers {
  avatarUrl?: string
}

export class LeduAppSubject {
  id?: string
  tempId?: string
  name?: string
}

export class LeduAppTerm {
  id?: string
  name?: string
}

export class LeduAppGrade {
  id?: string
  name?: string
}
